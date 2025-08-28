<?php
// insert new course
$input = json_decode(file_get_contents("php://input"), true) ?: $_POST;

$code = trim($input['code'] ?? '');
$title = trim($input['title'] ?? '');
$credits = (int)($input['credits'] ?? 0);
$desc = $input['description'] ?? '';
$schedule_day = $input['schedule_day'] ?? '';
$schedule_time = $input['schedule_time'] ?? '';
$room = $input['room'] ?? '';

if (!$code || !$title || $credits <= 0) {
    echo json_encode(['success' => false, 'error' => 'Missing required fields']);
    exit;
}

try {
    q($conn, "INSERT INTO courses (code, title, credits, description, schedule_day, schedule_time, room) VALUES (?,?,?,?,?,?,?)",
        [$code, $title, $credits, $desc, $schedule_day, $schedule_time, $room]);
    echo json_encode(['success' => true, 'id' => $conn->insert_id]);
} catch (Throwable $e) {
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
