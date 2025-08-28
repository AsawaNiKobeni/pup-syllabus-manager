<?php
$data = json_decode(file_get_contents("php://input"), true);
$id = (int)($data['id'] ?? 0);
$desc = $data['description'] ?? '';

if ($id <= 0) {
    echo json_encode(['error' => 'Invalid course id']);
    exit;
}

try {
    $stmt = $conn->prepare("UPDATE courses SET description=? WHERE id=?");
    $stmt->bind_param("si", $desc, $id);
    $stmt->execute();
    echo json_encode(['success' => true]);
} catch (Throwable $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
