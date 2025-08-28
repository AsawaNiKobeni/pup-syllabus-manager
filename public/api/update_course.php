<?php
// update course fields
$input = json_decode(file_get_contents("php://input"), true) ?: $_POST;

$id = (int)($input['id'] ?? 0);
if ($id <= 0) {
    echo json_encode(['success' => false, 'error' => 'Missing course id']);
    exit;
}

$code = trim($input['code'] ?? '');
$title = trim($input['title'] ?? '');
$credits = (int)($input['credits'] ?? 0);
$desc = $input['description'] ?? '';
$schedule_day = $input['schedule_day'] ?? '';
$schedule_time = $input['schedule_time'] ?? '';
$room = $input['room'] ?? '';

try {
    q($conn, "UPDATE courses SET code=?, title=?, credits=?, description=?, schedule_day=?, schedule_time=?, room=? WHERE id=?",
      [$code, $title, $credits, $desc, $schedule_day, $schedule_time, $room, $id]);
    echo json_encode(['success' => true]);
} catch (Throwable $e) {
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
