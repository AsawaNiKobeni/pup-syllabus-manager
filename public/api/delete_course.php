<?php
// delete course and related syllabi + children
$input = json_decode(file_get_contents("php://input"), true) ?: $_POST;
$id = (int)($input['id'] ?? $_GET['id'] ?? 0);
if ($id <= 0) {
    echo json_encode(['success' => false, 'error' => 'Missing course id']);
    exit;
}

try {
    // delete approvals, rubrics, faculty_info, bibliography, teaching_plan, sections linked to syllabi of this course
    q($conn, "DELETE a FROM approvals a JOIN syllabi s ON a.syllabus_id = s.id WHERE s.course_id = ?", [$id]);
    q($conn, "DELETE r FROM rubrics r JOIN syllabi s ON r.syllabus_id = s.id WHERE s.course_id = ?", [$id]);
    q($conn, "DELETE f FROM faculty_info f JOIN syllabi s ON f.syllabus_id = s.id WHERE s.course_id = ?", [$id]);
    q($conn, "DELETE b FROM bibliography b JOIN syllabi s ON b.syllabus_id = s.id WHERE s.course_id = ?", [$id]);
    q($conn, "DELETE tp FROM teaching_plan tp JOIN syllabi s ON tp.syllabus_id = s.id WHERE s.course_id = ?", [$id]);
    q($conn, "DELETE ss FROM syllabus_sections ss JOIN syllabi s ON ss.syllabus_id = s.id WHERE s.course_id = ?", [$id]);

    // delete syllabi for the course
    q($conn, "DELETE FROM syllabi WHERE course_id = ?", [$id]);

    // delete the course
    q($conn, "DELETE FROM courses WHERE id = ?", [$id]);

    echo json_encode(['success' => true]);
} catch (Throwable $e) {
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
