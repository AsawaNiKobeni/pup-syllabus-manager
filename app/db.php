<?php
require_once __DIR__ . '/config.php';

$conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
if ($conn->connect_error) {
    die("DB connect failed: " . $conn->connect_error);
}

function q($conn, $sql, $params = []) {
    $stmt = $conn->prepare($sql);
    if ($params) {
        $types = str_repeat("s", count($params));
        $stmt->bind_param($types, ...$params);
    }
    $stmt->execute();
    return $stmt->get_result();
}
