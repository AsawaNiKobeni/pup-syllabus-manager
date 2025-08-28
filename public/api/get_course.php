<?php
// returns one course + its syllabi (if any)
$id = (int)($_GET['id'] ?? 0);
if ($id <= 0) {
    echo json_encode(['error' => 'Missing course id']);
    exit;
}

try {
    $course = q($conn, "SELECT * FROM courses WHERE id = ?", [$id])->fetch_assoc();
    if (!$course) {
        echo json_encode(['error' => 'Course not found']);
        exit;
    }

    $syllabus = [];
    $res = q($conn, "SELECT * FROM syllabi WHERE course_id = ?", [$id]);
    while ($row = $res->fetch_assoc()) $syllabus[] = $row;

    echo json_encode(['course' => $course, 'syllabus' => $syllabus]);
} catch (Throwable $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
