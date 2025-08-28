<?php
require_once __DIR__ . '/../app/db.php';
header('Content-Type: application/json');

$action = $_GET['action'] ?? '';


function respond($data, $code = 200) {
  http_response_code($code);
  echo json_encode($data);
  exit;
}
function esc($conn, $v){ return $conn->real_escape_string($v ?? ''); }

/* =========================
   READ
========================= */
if ($action === 'get_courses') {
  $res = $conn->query("SELECT id, code, title FROM courses ORDER BY code");
  $rows = [];
  while ($r = $res->fetch_assoc()) $rows[] = $r;
  respond($rows);
}

if ($action === 'get_course') {
  $id = intval($_GET['id'] ?? 0);
  if (!$id) respond(["error"=>"Missing course id"], 400);

  // Course
  $course = $conn->query("SELECT * FROM courses WHERE id=$id")->fetch_assoc();
  if (!$course) respond(["error"=>"Course not found"], 404);

  // Latest syllabus shell for this course
  $syll = $conn->query("SELECT * FROM syllabi WHERE course_id=$id ORDER BY id DESC LIMIT 1")->fetch_assoc();
  $syllabus_id = $syll ? intval($syll['id']) : 0;

  // Sections
  $sections = [];
  if ($syllabus_id) {
    $sec_res = $conn->query("SELECT id, section_type, content FROM syllabus_sections WHERE syllabus_id=$syllabus_id");
    while ($r = $sec_res->fetch_assoc()) {
      $sections[$r['section_type']] = $sections[$r['section_type']] ?? [];
      $sections[$r['section_type']][] = $r; // keep id+content for editing
    }
  }

  // Teaching plan
  $tp = [];
  if ($syllabus_id) {
    $tp_res = $conn->query("SELECT id, week_no, desired_outcomes, topics, instructional_delivery, assessment, clo_alignment FROM teaching_plan WHERE syllabus_id=$syllabus_id ORDER BY week_no, id");
    while ($r = $tp_res->fetch_assoc()) $tp[] = $r;
  }

  // Bibliography
  $bib = [];
  if ($syllabus_id) {
    $bib_res = $conn->query("SELECT id, reference_text, url, type FROM bibliography WHERE syllabus_id=$syllabus_id");
    while ($r = $bib_res->fetch_assoc()) $bib[] = $r;
  }

  // Faculty
  $faculty = null;
  if ($syllabus_id) {
    $faculty = $conn->query("SELECT id, syllabus_id, name, consultation_time, contact, office FROM faculty_info WHERE syllabus_id=$syllabus_id LIMIT 1")->fetch_assoc();
  }

  // Rubrics
  $rubrics = [];
  if ($syllabus_id) {
    $rub = $conn->query("SELECT id, rubric_type, criteria, grading_scale FROM rubrics WHERE syllabus_id=$syllabus_id");
    while ($r = $rub->fetch_assoc()) $rubrics[] = $r;
  }

  // Approvals
  $approvals = [];
  if ($syllabus_id) {
    $app = $conn->query("SELECT id, role, name, approval_date FROM approvals WHERE syllabus_id=$syllabus_id");
    while ($r = $app->fetch_assoc()) $approvals[] = $r;
  }

  respond([
    "course" => $course,
    "syllabus" => $syll,
    "sections" => $sections,
    "teaching_plan" => $tp,
    "bibliography" => $bib,
    "faculty" => $faculty,
    "rubrics" => $rubrics,
    "approvals" => $approvals
  ]);
}

/* =========================
   UPDATE HELPERS
========================= */
function build_set_clause($conn, $whitelist, $src) {
  $set = [];
  foreach ($whitelist as $field) {
    if (array_key_exists($field, $src)) {
      $val = esc($conn, $src[$field]);
      $set[] = "$field='$val'";
    }
  }
  return implode(',', $set);
}

/* =========================
   UPDATE: Course (meta)
========================= */
if ($action === 'update_course') {
  $id = intval($_POST['id'] ?? 0);
  if (!$id) respond(["error"=>"Missing course id"], 400);

  $allowed = ['code','title','credits','description','prereq','coreq','schedule_day','schedule_time','room'];
  $set = build_set_clause($conn, $allowed, $_POST);
  if (!$set) respond(["error"=>"No fields to update"], 400);

  $sql = "UPDATE courses SET $set WHERE id=$id";
  if (!$conn->query($sql)) respond(["error"=>$conn->error], 500);
  respond(["success"=>true]);
}

/* =========================
   UPDATE: Faculty (upsert)
========================= */
if ($action === 'update_faculty') {
  $syllabus_id = intval($_POST['syllabus_id'] ?? 0);
  if (!$syllabus_id) respond(["error"=>"Missing syllabus_id"], 400);

  $name = esc($conn, $_POST['name'] ?? '');
  $consultation_time = esc($conn, $_POST['consultation_time'] ?? '');
  $contact = esc($conn, $_POST['contact'] ?? '');
  $office = esc($conn, $_POST['office'] ?? '');

  $exists = $conn->query("SELECT id FROM faculty_info WHERE syllabus_id=$syllabus_id LIMIT 1")->fetch_assoc();
  if ($exists) {
    $id = intval($exists['id']);
    $sql = "UPDATE faculty_info SET name='$name', consultation_time='$consultation_time', contact='$contact', office='$office' WHERE id=$id";
  } else {
    $sql = "INSERT INTO faculty_info (syllabus_id, name, consultation_time, contact, office)
            VALUES ($syllabus_id, '$name', '$consultation_time', '$contact', '$office')";
  }
  if (!$conn->query($sql)) respond(["error"=>$conn->error], 500);
  respond(["success"=>true]);
}

/* =========================
   UPDATE: Teaching plan row
========================= */
if ($action === 'update_teaching_plan') {
  $id = intval($_POST['id'] ?? 0);
  if (!$id) respond(["error"=>"Missing teaching plan id"], 400);

  $allowed = ['week_no','desired_outcomes','topics','instructional_delivery','assessment','clo_alignment'];
  $set = build_set_clause($conn, $allowed, $_POST);
  if (!$set) respond(["error"=>"No fields to update"], 400);

  $sql = "UPDATE teaching_plan SET $set WHERE id=$id";
  if (!$conn->query($sql)) respond(["error"=>$conn->error], 500);
  respond(["success"=>true]);
}

/* =========================
   UPDATE: One section (upsert by section_type)
========================= */
if ($action === 'update_section') {
  $syllabus_id = intval($_POST['syllabus_id'] ?? 0);
  $section_type = esc($conn, $_POST['section_type'] ?? '');
  $content = esc($conn, $_POST['content'] ?? '');
  if (!$syllabus_id || !$section_type) respond(["error"=>"Missing syllabus_id or section_type"], 400);

  $row = $conn->query("SELECT id FROM syllabus_sections WHERE syllabus_id=$syllabus_id AND section_type='$section_type' LIMIT 1")->fetch_assoc();
  if ($row) {
    $id = intval($row['id']);
    $sql = "UPDATE syllabus_sections SET content='$content' WHERE id=$id";
  } else {
    $sql = "INSERT INTO syllabus_sections (syllabus_id, section_type, content) VALUES ($syllabus_id, '$section_type', '$content')";
  }
  if (!$conn->query($sql)) respond(["error"=>$conn->error], 500);
  respond(["success"=>true]);
}

/* =========================
   UPDATE: Bibliography row
========================= */
if ($action === 'update_bibliography') {
  $id = intval($_POST['id'] ?? 0);
  if (!$id) respond(["error"=>"Missing bibliography id"], 400);
  $allowed = ['reference_text','url','type'];
  $set = build_set_clause($conn, $allowed, $_POST);
  if (!$set) respond(["error"=>"No fields to update"], 400);

  $sql = "UPDATE bibliography SET $set WHERE id=$id";
  if (!$conn->query($sql)) respond(["error"=>$conn->error], 500);
  respond(["success"=>true]);
}

/* =========================
   UPDATE: Rubric row
========================= */
if ($action === 'update_rubric') {
  $id = intval($_POST['id'] ?? 0);
  if (!$id) respond(["error"=>"Missing rubric id"], 400);
  $allowed = ['rubric_type','criteria','grading_scale'];
  $set = build_set_clause($conn, $allowed, $_POST);
  if (!$set) respond(["error"=>"No fields to update"], 400);

  $sql = "UPDATE rubrics SET $set WHERE id=$id";
  if (!$conn->query($sql)) respond(["error"=>$conn->error], 500);
  respond(["success"=>true]);
}

/* =========================
   UPDATE: Approval row
========================= */
if ($action === 'update_approval') {
  $id = intval($_POST['id'] ?? 0);
  if (!$id) respond(["error"=>"Missing approval id"], 400);
  $allowed = ['role','name','approval_date'];
  $set = build_set_clause($conn, $allowed, $_POST);
  if (!$set) respond(["error"=>"No fields to update"], 400);

  $sql = "UPDATE approvals SET $set WHERE id=$id";
  if (!$conn->query($sql)) respond(["error"=>$conn->error], 500);
  respond(["success"=>true]);
}

// === INLINE LIST UPDATE FOR SECTIONS ===
if ($action === 'update_section') {
    $input = json_decode(file_get_contents('php://input'), true);
    $section = esc($conn, $input['section_type'] ?? $input['section'] ?? '');
    $content = esc($conn, $input['content'] ?? '');
    $syllabus_id = intval($input['syllabus_id'] ?? 0);

    if (!$section || !$syllabus_id) {
        respond(["error" => "Missing syllabus_id or section type"], 400);
    }

    // Upsert by clearing and inserting new combined content
    $conn->query("DELETE FROM syllabus_sections WHERE syllabus_id=$syllabus_id AND section_type='$section'");
    $sql = "INSERT INTO syllabus_sections (syllabus_id, section_type, content) VALUES ($syllabus_id, '$section', '$content')";
    if (!$conn->query($sql)) {
        respond(["error" => $conn->error], 500);
    }

    respond(["success" => true]);
}

if ($action === 'create_syllabus') {
    $course_id = intval($_POST['course_id'] ?? 0);
    if (!$course_id) respond(["error"=>"Missing course_id"],400);

    $conn->query("INSERT INTO syllabi (course_id, created_at) VALUES ($course_id, NOW())");
    $syllabus_id = $conn->insert_id;

    respond(["success"=>true,"syllabus_id"=>$syllabus_id]);
}

/* =========================
   CREATE NEW COURSE WITH FULL CONTENT
========================= */
if ($action === 'add_course') {
    $input = json_decode(file_get_contents('php://input'), true);

    // 1. Insert course meta
    $code = esc($conn, $input['code'] ?? '');
    $title = esc($conn, $input['title'] ?? '');
    $credits = intval($input['credits'] ?? 0);
    $description = esc($conn, $input['description'] ?? '');
    $prereq = esc($conn, $input['prereq'] ?? '');
    $coreq = esc($conn, $input['coreq'] ?? '');
    $schedule_day = esc($conn, $input['schedule_day'] ?? '');
    $schedule_time = esc($conn, $input['schedule_time'] ?? '');
    $room = esc($conn, $input['room'] ?? '');

    $sql = "INSERT INTO courses 
        (code, title, credits, description, prereq, coreq, schedule_day, schedule_time, room)
        VALUES ('$code', '$title', $credits, '$description', '$prereq', '$coreq', '$schedule_day', '$schedule_time', '$room')";
    if (!$conn->query($sql)) respond(["error"=>$conn->error], 500);
    $course_id = $conn->insert_id;

    // 2. Create syllabus
    $conn->query("INSERT INTO syllabi (course_id, created_at) VALUES ($course_id, NOW())");
    $syllabus_id = $conn->insert_id;

    // 3. Faculty
    if(!empty($input['faculty'])) {
        $fac = $input['faculty'];
        $name = esc($conn, $fac['name'] ?? '');
        $consultation = esc($conn, $fac['consultation'] ?? '');
        $contact = esc($conn, $fac['contact'] ?? '');
        $office = esc($conn, $fac['office'] ?? '');
        $conn->query("INSERT INTO faculty_info (syllabus_id, name, consultation_time, contact, office)
                      VALUES ($syllabus_id, '$name', '$consultation', '$contact', '$office')");
    }

    // 4. Sections
    if(!empty($input['sections'])) {
        foreach($input['sections'] as $section_type => $content) {
            $content = esc($conn, $content);
            $conn->query("INSERT INTO syllabus_sections (syllabus_id, section_type, content)
                          VALUES ($syllabus_id, '$section_type', '$content')");
        }
    }

    // 5. Teaching Plan
    if(!empty($input['teaching_plan'])) {
        foreach($input['teaching_plan'] as $tp) {
            $week = intval($tp['week'] ?? 0);
            $desired_outcomes = esc($conn, $tp['outcomes'] ?? '');
            $topics = esc($conn, $tp['topics'] ?? '');
            $delivery = esc($conn, $tp['delivery'] ?? '');
            $assessment = esc($conn, $tp['assessment'] ?? '');
            $clo = esc($conn, $tp['clo'] ?? '');
            $conn->query("INSERT INTO teaching_plan (syllabus_id, week_no, desired_outcomes, topics, instructional_delivery, assessment, clo_alignment)
                          VALUES ($syllabus_id, $week, '$desired_outcomes', '$topics', '$delivery', '$assessment', '$clo')");
        }
    }

    // 6. Bibliography
    if(!empty($input['bibliography'])) {
        foreach($input['bibliography'] as $b) {
            $ref = esc($conn, $b['reference'] ?? '');
            $url = esc($conn, $b['url'] ?? '');
            $type = esc($conn, $b['type'] ?? '');
            $conn->query("INSERT INTO bibliography (syllabus_id, reference_text, url, type)
                          VALUES ($syllabus_id, '$ref', '$url', '$type')");
        }
    }

    // 7. Rubrics
    if(!empty($input['rubrics'])) {
        foreach($input['rubrics'] as $r) {
            $type = esc($conn, $r['type'] ?? '');
            $criteria = esc($conn, $r['criteria'] ?? '');
            $scale = esc($conn, $r['scale'] ?? '');
            $conn->query("INSERT INTO rubrics (syllabus_id, rubric_type, criteria, grading_scale)
                          VALUES ($syllabus_id, '$type', '$criteria', '$scale')");
        }
    }

    // 8. Approvals
    if(!empty($input['approvals'])) {
        foreach($input['approvals'] as $a) {
            $name = esc($conn, $a['name'] ?? '');
            $role = esc($conn, $a['position'] ?? '');
            $date = esc($conn, $a['date'] ?? '');
            $conn->query("INSERT INTO approvals (syllabus_id, role, name, approval_date)
                          VALUES ($syllabus_id, '$role', '$name', '$date')");
        }
    }

    respond(["success"=>true, "course_id"=>$course_id, "syllabus_id"=>$syllabus_id]);
}

/* =========================
   DELETE: Course + related data
========================= */
if ($action === 'delete_course') {
    $id = intval($_POST['id'] ?? 0);
    if (!$id) respond(["error"=>"Missing course id"], 400);

    // Delete course → but also clean up related records
    // (foreign key constraints with ON DELETE CASCADE would be better if set up)
    $conn->query("DELETE FROM approvals WHERE syllabus_id IN (SELECT id FROM syllabi WHERE course_id=$id)");
    $conn->query("DELETE FROM rubrics WHERE syllabus_id IN (SELECT id FROM syllabi WHERE course_id=$id)");
    $conn->query("DELETE FROM bibliography WHERE syllabus_id IN (SELECT id FROM syllabi WHERE course_id=$id)");
    $conn->query("DELETE FROM teaching_plan WHERE syllabus_id IN (SELECT id FROM syllabi WHERE course_id=$id)");
    $conn->query("DELETE FROM syllabus_sections WHERE syllabus_id IN (SELECT id FROM syllabi WHERE course_id=$id)");
    $conn->query("DELETE FROM faculty_info WHERE syllabus_id IN (SELECT id FROM syllabi WHERE course_id=$id)");
    $conn->query("DELETE FROM syllabi WHERE course_id=$id");

    $ok = $conn->query("DELETE FROM courses WHERE id=$id");

    if (!$ok) respond(["error"=>$conn->error], 500);
    respond(["success"=>true]);
}
respond(["error"=>"Unknown action"], 404);