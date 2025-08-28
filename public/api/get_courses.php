<?php
// returns all courses
try {
    $res = q($conn, "SELECT id, code, title, credits, description FROM courses ORDER BY code");
    $out = [];
    if ($res instanceof mysqli_result) {
        while ($row = $res->fetch_assoc()) $out[] = $row;
    }
    echo json_encode($out);
} catch (Throwable $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
