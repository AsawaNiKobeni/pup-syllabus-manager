-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 28, 2025 at 05:03 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `syllabus_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `approvals`
--

CREATE TABLE `approvals` (
  `id` int(11) NOT NULL,
  `syllabus_id` int(11) NOT NULL,
  `role` varchar(100) DEFAULT NULL,
  `name` varchar(150) DEFAULT NULL,
  `signature_path` varchar(255) DEFAULT NULL,
  `approval_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `approvals`
--

INSERT INTO `approvals` (`id`, `syllabus_id`, `role`, `name`, `signature_path`, `approval_date`) VALUES
(1, 1, 'Prepared by', 'Noel C. Gagolinan, MIT', NULL, '2023-10-30'),
(2, 1, 'Program Head', 'Assoc. Prof. Alfed M. Pagalilawan', NULL, '2023-10-30'),
(3, 1, 'Director', 'Assoc. Prof. Edgardo S. Delmo', NULL, '2023-10-30'),
(4, 1, 'Vice President for Branches & Satellite Campuses', 'Prof. Pascualito B. Gatan', NULL, '2023-10-30'),
(5, 1, 'Student Acknowledgment', '(Printed name and signature of student)', NULL, NULL),
(15, 4, 'Prepared by', 'Asst. Prof. Noel C. Gagolinan, MIT', NULL, '2025-02-28'),
(16, 4, 'Program Head', 'Assoc. Prof. Alfed M. Pagalilawan', NULL, '2025-02-28'),
(17, 4, 'Director', 'Dr. Cecilia Reyes-Alagon', NULL, '2025-02-28'),
(18, 4, 'Vice President for Branches & Campuses', 'Prof. Pascualito B. Gatan', NULL, '2025-02-28'),
(19, 4, 'Student Acknowledgment', '(Printed name and signature of student)', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `bibliography`
--

CREATE TABLE `bibliography` (
  `id` int(11) NOT NULL,
  `syllabus_id` int(11) NOT NULL,
  `reference_text` text DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `type` enum('book','online','extended') DEFAULT 'book'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bibliography`
--

INSERT INTO `bibliography` (`id`, `syllabus_id`, `reference_text`, `url`, `type`) VALUES
(1, 1, 'Modern Linux Administration: How to Become a Cutting-edge Linux Administrator (Sam Alapati, 2016)', NULL, 'book'),
(2, 1, 'Linux Administration: A Beginner’s Guide (Wale Soyinka, 2012)', NULL, 'book'),
(3, 1, 'UNIX and Linux System Administration Handbook (Evi Nemeth, Garth Snyder, Trent R. Hein, Ben Whaley), 4th Ed., 2011', NULL, 'book'),
(4, 1, 'UNIX and Linux System Administration (Nemeth et al.), 4th ed., 2010', NULL, 'book'),
(5, 1, 'YouTube playlist: Linux Admin basics', 'https://www.youtube.com/watch?v=Wgi-OfbP2Gw&list=PL9ooVrP1hQOH3SvcgkC4Qv2cyCebvs0Ik', 'online'),
(6, 1, 'YouTube: Linux tutorial 1', 'https://www.youtube.com/watch?v=qAMWG86sEm8', 'online'),
(7, 1, 'YouTube: Linux tutorial 2', 'https://www.youtube.com/watch?v=HbgzrKJvDRw', 'online'),
(8, 1, 'Extended readings to be assigned by faculty', NULL, 'extended'),
(19, 4, 'Odom, Wendell (2021). CCNA 200-301 Official Cert Guide, Vol. 1 & 2. Cisco Press.', NULL, 'book'),
(20, 4, 'Tetz, Cameron & Prowse, David (2022). CompTIA Network+ Guide to Managing and Troubleshooting Networks. McGraw-Hill.', NULL, 'book'),
(21, 4, 'Andrews, Jean (2020). A+ Guide to IT Technical Support, 10th Ed. Cengage.', NULL, 'book'),
(22, 4, 'Doyle, Jeff & Carroll, Jennifer (2020). Routing TCP/IP, Vol.1 (2nd Ed). Cisco Press.', NULL, 'book'),
(23, 4, 'Miller, Michael (2019). Cybersecurity Essentials. Pearson.', NULL, 'book');

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `credits` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `prereq` varchar(100) DEFAULT NULL,
  `coreq` varchar(100) DEFAULT NULL,
  `schedule_day` varchar(100) DEFAULT NULL,
  `schedule_time` varchar(100) DEFAULT NULL,
  `room` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `code`, `title`, `credits`, `description`, `prereq`, `coreq`, `schedule_day`, `schedule_time`, `room`) VALUES
(1, 'INTE 30083', 'System Administration and Maintenance', 3, 'This course is intended for students majoring in information technology. It concentrates in system administration and maintenance of a Linux operating system and also tacles network administration. In addition on learning how to create administrative policies and procedures, students will also learn how to install, manage, and expand multiuser computer systems. In order to solve user and system problems, students will also learn how to apply problem-solving and troubleshooting techniques.', 'None', 'None', 'Thursday', '9:00am–12:00pm; 1:00–3:00pm', 'COM LAB1'),
(12, 'COMP 012', 'Network Administration', 3, 'Provides an introduction to principles and practices of network administration. Covers network design, implementation, management, and security with hands-on configuration, maintenance, and troubleshooting of computer networks.', 'DATA COMMUNICATIONS', 'None', 'Friday–Saturday', 'Fri 12:30–5:30pm; Fri 6:00–9:00pm; Sat 7:00–9:00am', 'COMLAB 3 (Fri), COMLAB 1 (Sat)');

-- --------------------------------------------------------

--
-- Table structure for table `faculty_info`
--

CREATE TABLE `faculty_info` (
  `id` int(11) NOT NULL,
  `syllabus_id` int(11) NOT NULL,
  `name` varchar(150) DEFAULT NULL,
  `consultation_time` varchar(150) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `office` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faculty_info`
--

INSERT INTO `faculty_info` (`id`, `syllabus_id`, `name`, `consultation_time`, `contact`, `office`) VALUES
(1, 1, 'Noel C. Gagolinan, MIT', 'TBA', 'TBA', 'IT Department'),
(4, 4, 'Asst. Prof. Noel C. Gagolinan, MIT', 'TBA', 'TBA', 'IT Department');

-- --------------------------------------------------------

--
-- Table structure for table `rubrics`
--

CREATE TABLE `rubrics` (
  `id` int(11) NOT NULL,
  `syllabus_id` int(11) NOT NULL,
  `rubric_type` varchar(100) DEFAULT NULL,
  `criteria` text DEFAULT NULL,
  `grading_scale` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rubrics`
--

INSERT INTO `rubrics` (`id`, `syllabus_id`, `rubric_type`, `criteria`, `grading_scale`) VALUES
(1, 1, 'Program Design', 'Solution planning and design quality.', '25=well thought out; 15=partially planned; 5=ad hoc.'),
(2, 1, 'Program Execution', 'Correctness of execution.', '20=runs correctly; 12=partially correct; 4=mostly incorrect; 0=does not run.'),
(3, 1, 'Specification Satisfaction', 'Meets requirements completely and correctly.', '25=complete/correct; 15=some parts missing; 5=does not satisfy.'),
(4, 1, 'Coding Style', 'Code organization and style quality.', '20=well thought out; 12=partial; 4=ad hoc.'),
(5, 1, 'Comments', 'Quality of comments.', '5=concise/meaningful; 3=partial/poor; 2=wordy/incorrect; 0=none.'),
(6, 1, 'Extra Credits', 'Value-adding improvements.', '5=useful extensions/good algorithms/well written.'),
(17, 4, 'Network Design', 'Topology diagram, IP scheme, configs, principle understanding.', '25=excellent; 15=good; 5=fair; 0=poor'),
(18, 4, 'Device Configuration', 'Accuracy, completeness, best practices.', '25=excellent; 15=good; 5=fair; 0=poor'),
(19, 4, 'Functionality & Testing', 'Devices communicate, testing documented.', '25=excellent; 15=good; 5=fair; 0=poor'),
(20, 4, 'Security Implementation', 'ACLs, secure protocols, documentation.', '20=excellent; 15=good; 5=fair; 0=poor'),
(21, 4, 'Documentation & Presentation', 'Professional clarity, concise, organized.', '5=excellent; 3=good; 2=fair; 1=poor');

-- --------------------------------------------------------

--
-- Table structure for table `syllabi`
--

CREATE TABLE `syllabi` (
  `id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `version` varchar(50) DEFAULT NULL,
  `semester` varchar(50) DEFAULT NULL,
  `academic_year` varchar(50) DEFAULT NULL,
  `overview` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `syllabi`
--

INSERT INTO `syllabi` (`id`, `course_id`, `version`, `semester`, `academic_year`, `overview`) VALUES
(1, 1, 'v20231030.2121', '1st Semester', 'AY 2023–2024', 'Course overview: Linux/UNIX background; server installation and configuration; user/group management; package management; command line; assessments include quizzes, lab/machine problems, projects, and major exams.'),
(4, 12, 'v20250418.2313', '2nd Semester', 'AY 2024–2025', 'Course overview: Networking fundamentals, cabling, Ethernet & switching, VLANs, routing (static/dynamic), NAT/DHCP, firewalls & ACLs, IDS/IPS, wireless networks, network operating systems, server administration, monitoring & troubleshooting. Assessments include quizzes, labs, projects, and exams.');

-- --------------------------------------------------------

--
-- Table structure for table `syllabus_sections`
--

CREATE TABLE `syllabus_sections` (
  `id` int(11) NOT NULL,
  `syllabus_id` int(11) NOT NULL,
  `section_type` varchar(100) DEFAULT NULL,
  `content` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `syllabus_sections`
--

INSERT INTO `syllabus_sections` (`id`, `syllabus_id`, `section_type`, `content`) VALUES
(1, 1, 'Vision', 'PUP: The National Polytechnic University (Pambansang Politeknikong Unibersidad).'),
(2, 1, 'Mission', 'Provide inclusive and equitable quality education and promote lifelong learning through democratized access, industry-oriented curricula, a culture of research and innovation, continuous faculty development, and active engagement with stakeholders.'),
(3, 1, 'Quality Policy', 'Commitment to inclusive, equitable quality education and continuous improvement via a Quality Management System to meet client satisfaction and advance social transformation.'),
(4, 1, 'Institutional Learning Outcomes (ILO)', '1) Critical & Creative Thinking; 2) Effective Communication; 3) Service Orientation; 4) Responsible Tech Use/Development; 5) Lifelong Learning; 6) Leadership & Organization; 7) Personal & Professional Ethics; 8) Resilience & Agility; 9) National & Global Responsiveness'),
(5, 1, 'Campus Goals', 'Academic excellence; Empowered faculty & employees; Strong research engagement; Evidence-based outreach/extension; Knowledge management; Enduring academic community.'),
(6, 1, 'Program Learning Outcomes (PLO)', 'Apply computing fundamentals and specialization knowledge; Analyze and solve complex problems; Address information security in design/use of IS; Design/evaluate solutions meeting specified needs; Function effectively in teams; Communicate effectively; Uphold professional ethics; Pursue independent lifelong learning.'),
(7, 1, 'Performance Indicators (PI)', 'Design/implement/test/debug systems from specification; Justify architectures; Identify strengths/weaknesses of security approaches; Describe controls for protecting information systems; Develop appropriate UIs; Evaluate infra components across environments; Collaborate on methodologies and best solutions; Present and justify solutions using scientific methods; Analyze organizational computing solutions; Engage in industry immersion; Evaluate professional/ethical/social issues; Produce independent learning reports; Identify and use legitimate tech information sources.'),
(8, 1, 'Course Learning Outcomes (CLO)', '1) Summarize UNIX/Linux history.; 2) Differentiate Linux vs Windows.; 3) Install and configure a server.; 4) Modify server using management tools, test for anomalies, simulate deployment.; 5) Create users identify parts of passwd, shadow, group files. (Aligned to program outcomes).'),
(9, 1, 'Classroom Policies', '≥4 Quizzes; Assignments/case studies or research projects throughout the term; Late penalties may apply; Regular attendance required; Academic integrity enforced; Keep graded work; Syllabus may be updated with notice; Obey lab/classroom rules (no gadgets during exams/lab work no food/drinks). '),
(10, 1, 'Grading System', 'MIDTERM: Class Standing 60% (Attendance 10% Homework/Schoolwork 25% Projects 25%), Major Exam 40%.; FINAL: Class Standing 60% (same breakdown), Major Exam 40%. Final Grade = 50% Midterm + 50% Final Major Exam may be replaced by major project/actual machine problem.'),
(26, 1, 'Program Learning Outcomes (PLO)', 'Apply computing fundamentals; analyze/solve problems; address information security; design/evaluate solutions; work in teams; communicate effectively; uphold ethics; pursue lifelong learning.'),
(27, 1, 'Performance Indicators (PI)', 'Design/test systems; justify network architectures; evaluate security controls; analyze infra components; collaborate on solutions; present proposals effectively.'),
(28, 1, 'Course Learning Outcomes (CLO)', '1) Design & implement LANs. 2) Configure and manage routers/switches. 3) Troubleshoot connectivity issues. 4) Implement network security. 5) Understand network OS and server administration.'),
(29, 1, 'Classroom Policies', '≥4 quizzes; assignments/case studies; late penalty 5%/day; attendance required; cheating penalized; keep graded work; no gadgets/food/drinks in class; syllabus may change with notice.'),
(30, 1, 'Grading System', 'MIDTERM: Class Standing 60% (Attendance 10%, Homework 25%, Projects 25%) + Major Exam 40%. FINAL: Same breakdown. Final Grade = 50% Midterm + 50% Final. Major Exam may be replaced with project/machine problem.'),
(31, 4, 'Vision', 'PUP: The National Polytechnic University (Pambansang Politeknikong Unibersidad).'),
(32, 4, 'Mission', 'Provide inclusive and equitable quality education and lifelong learning through democratized access, industry-oriented curricula, research and innovation, faculty professionalism, and stakeholder engagement.'),
(33, 4, 'Quality Policy', 'Commitment to provide inclusive, equitable education and promote continuous improvement through a Quality Management System for human advancement and social transformation.'),
(34, 4, 'Institutional Learning Outcomes (ILO)', '1) Critical & Creative Thinking; 2) Effective Communication; 3) Service Orientation; 4) Responsible Tech Use; 5) Lifelong Learning; 6) Leadership; 7) Ethics; 8) Resilience; 9) National & Global Responsiveness.'),
(35, 4, 'Campus Goals', 'Innovative curricula; Empowered faculty; Holistic Student Development; Research Innovation; Impactful Extension Programs; Expanded Local and Global Networks; Transformational Leadership.'),
(36, 4, 'Program Learning Outcomes (PLO)', 'Apply computing fundamentals; Analyze/solve problems; Address information security; Design/evaluate solutions; Work in teams; Communicate effectively; Uphold ethics; Pursue lifelong learning.'),
(37, 4, 'Performance Indicators (PI)', 'Design/test systems; Justify network architectures; Evaluate security controls; Analyze infra components; Collaborate on solutions; Present proposals effectively.'),
(38, 4, 'Course Learning Outcomes (CLO)', '1) Design & implement LANs.; 2) Configure and manage routers/switches.; 3) Troubleshoot connectivity issues.; 4) Implement network security.; 5) Understand network OS and server administration.'),
(39, 4, 'Classroom Policies', '≥4 quizzes; Assignments/case studies; Late penalty 5%/day; Attendance required; Cheating penalized; Keep graded work; No gadgets/food/drinks in class; Syllabus may change with notice.'),
(40, 4, 'Grading System', 'MIDTERM: Class Standing 60% (Attendance 10%, Homework 25%, Projects 25%) + Major Exam 40%.; FINAL:  Class Standing 60% (Attendance 10%, Homework 25%, Projects 25%) Final Grade = 50% Midterm + 50% Final. Major Exam may be replaced with project/machine problem.');

-- --------------------------------------------------------

--
-- Table structure for table `teaching_plan`
--

CREATE TABLE `teaching_plan` (
  `id` int(11) NOT NULL,
  `syllabus_id` int(11) NOT NULL,
  `week_no` int(11) NOT NULL,
  `desired_outcomes` text DEFAULT NULL,
  `topics` text DEFAULT NULL,
  `instructional_delivery` text DEFAULT NULL,
  `assessment` text DEFAULT NULL,
  `clo_alignment` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teaching_plan`
--

INSERT INTO `teaching_plan` (`id`, `syllabus_id`, `week_no`, `desired_outcomes`, `topics`, `instructional_delivery`, `assessment`, `clo_alignment`) VALUES
(1, 1, 1, 'Orient to syllabus, grading, and classroom management; connect VMGOs to course.', 'Course intro; VMGO; grading; rules (F2F & online).', 'Discussion (F2F/Online); introductions; Zoom as needed.', 'Participation.', ''),
(2, 1, 2, 'Understand Linux history and basics.', 'Intro to Linux; history from UNIX to Linux.', 'Board work; lecture; exercises; interactive recitation; videos; tools (Mentimeter/Mural/Jamboard).', 'Assignment(s).', 'CLO 1'),
(3, 1, 3, 'Continue Linux history and basics.', '(cont.) Intro to Linux; UNIX→Linux timeline.', 'Lecture; exercises; discussions; video.', 'Homework; participation.', 'CLO 1'),
(4, 1, 4, 'Compare Linux vs Windows; grasp OSS concepts.', 'Open Source & GNU; GPL; upstream/downstream; advantages of OSS; Windows vs Linux differences (users, kernel, registry vs text files, domains/AD).', 'Lecture; board work; recitation (chat ok).', 'Quiz; assignment.', 'CLO 2'),
(5, 1, 5, 'Deepen comparison; summarize differences.', 'Monolithic vs micro-kernel; GUI vs kernel; network neighborhood; registry vs text; summary.', 'Lecture; exercises; recitation.', 'Quiz; assignment.', 'CLO 2'),
(6, 1, 6, 'Prepare for server setup.', 'Hardware/env considerations; server design; uptime; install methods; prerequisites.', 'Lecture; exercises; recitation.', 'Quiz; lab activity.', 'CLO 3'),
(7, 1, 7, 'Install Linux server.', 'Ubuntu Server install; initial configuration.', 'Lecture; guided lab.', 'Lab activity.', 'CLO 3'),
(8, 1, 8, 'Validate initial server setup.', 'Post-install checks; initial services.', 'Lecture; exercises.', 'Quiz; lab.', 'CLO 3'),
(9, 1, 9, 'Assess midterm learning.', 'MIDTERM EXAM.', 'Proctored exam.', 'Midterm exam.', ''),
(10, 1, 10, 'Manage software packages.', 'RPM; GUI RPM tools; Debian/Ubuntu APT; querying; installing/removing; build from source (configure/make/test/cleanup).', 'Board work; lecture; recitation; async video.', 'Lab activity.', 'CLO 3'),
(11, 1, 11, 'Troubleshoot package builds.', 'Common build problems (libraries, missing configure, broken source).', 'Lecture; exercises.', 'Lab; quiz.', 'CLO 3'),
(12, 1, 12, 'Apply software mgmt in Ubuntu.', 'Install/remove/test packages; documentation and cleanup.', 'Lecture; exercises.', 'Lab; assignment.', 'CLO 3'),
(13, 1, 13, 'Understand users/groups and account files.', 'What is a user; /etc/passwd; /etc/shadow; /etc/group.', 'Lecture; exercises; recitation.', 'Quiz; lab.', 'CLO 5'),
(14, 1, 14, 'Use command-line user mgmt and permissions.', 'useradd/usermod/userdel; groupadd/groupmod/groupdel; access permissions; setuid/setgid.', 'Lecture; exercises; async activity.', 'Lab activity.', 'CLO 4'),
(15, 1, 15, 'Use bash effectively.', 'Bash intro; job control; env vars; pipes; redirection; shortcuts.', 'Lecture; exercises; recitation.', 'Quiz; lab.', 'CLO 4'),
(16, 1, 16, 'Use docs/tools.', 'man; texinfo; multiple commands; backticks; filename expansion.', 'Lecture; exercises.', 'Assignment; lab.', 'CLO 4'),
(17, 1, 17, 'Understand files, types, ownership, permissions.', 'Normal files; directories; hard/symlinks; block/char devices; named pipes.', 'Lecture; lab.', 'Quiz; lab.', 'CLO 4'),
(18, 1, 18, 'Assess overall learning.', 'FINAL EXAMINATION.', 'Proctored exam.', 'Final exam.', ''),
(55, 4, 1, 'Orientation; VMGO; syllabus overview.', 'Course intro; VMGO; grading; rules.', 'Lecture/discussion (F2F/Online).', 'Participation.', ''),
(56, 4, 2, 'Explain networking basics & OSI/TCP-IP.', 'Networking concepts; hardware; models.', 'Lecture; board work; video.', 'Recitation.', 'CLO 1'),
(57, 4, 3, 'Differentiate network media & cabling.', 'Copper, fiber, wireless, standards.', 'Lecture; exercises.', 'Assignment.', 'CLO 1'),
(58, 4, 4, 'Understand Ethernet & switching.', 'Ethernet standards; MAC; ARP; switches.', 'Lecture; exercises.', 'Recitation.', 'CLO 1,2'),
(59, 4, 5, 'Configure VLANs & STP.', 'VLANs; inter-VLAN; STP.', 'Lecture; exercises.', 'Quiz.', 'CLO 2'),
(60, 4, 6, 'Apply IP addressing & subnetting.', 'IPv4 classes, subnetting, CIDR.', 'Lecture; exercises.', 'Recitation.', 'CLO 1'),
(61, 4, 7, 'Differentiate routing types.', 'Static vs dynamic routing; overview.', 'Lecture; exercises.', 'Quiz.', 'CLO 2'),
(62, 4, 8, 'Understand RIP & OSPF.', 'Dynamic routing protocols.', 'Lecture; video.', 'Recitation.', 'CLO 2'),
(63, 4, 9, 'MIDTERM EXAM.', '--', 'Proctored exam.', 'Midterm Exam.', ''),
(64, 4, 10, 'Explain NAT & DHCP.', 'NAT concepts; DHCP config.', 'Lecture; lab.', 'Quiz.', 'CLO 2'),
(65, 4, 11, 'Identify security threats.', 'Intro to network security.', 'Lecture; exercises.', 'Assignment.', 'CLO 4'),
(66, 4, 12, 'Use firewalls & ACLs.', 'Concepts; configuration.', 'Lecture; lab.', 'Recitation.', 'CLO 4'),
(67, 4, 13, 'Understand IDS & IPS.', 'Detection vs prevention.', 'Lecture; exercises.', 'Recitation.', 'CLO 4'),
(68, 4, 14, 'Configure wireless networks.', '802.11 standards; WPA/WPA2/WPA3.', 'Lecture; lab.', 'Quiz.', 'CLO 1,4'),
(69, 4, 15, 'Understand NOS.', 'Features; administration tasks.', 'Lecture; discussion.', 'Recitation.', 'CLO 5'),
(70, 4, 16, 'Basics of server admin.', 'User/group mgmt; file sharing.', 'Lecture; lab.', 'Quiz.', 'CLO 5'),
(71, 4, 17, 'Apply monitoring & troubleshooting.', 'Tools; methodologies; analysis.', 'Lecture; lab.', 'Assignment.', 'CLO 3'),
(72, 4, 18, 'FINAL EXAM.', '--', 'Proctored exam.', 'Final Exam.', '');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','faculty') DEFAULT 'admin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`) VALUES
(1, 'admin', '$2y$10$Vh8JvFQW4S1g9I2q6EwJ7e1rGQk8q8uN7q3H1x6v1mCwqk7a8b9rK', 'admin');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `approvals`
--
ALTER TABLE `approvals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `syllabus_id` (`syllabus_id`);

--
-- Indexes for table `bibliography`
--
ALTER TABLE `bibliography`
  ADD PRIMARY KEY (`id`),
  ADD KEY `syllabus_id` (`syllabus_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `faculty_info`
--
ALTER TABLE `faculty_info`
  ADD PRIMARY KEY (`id`),
  ADD KEY `syllabus_id` (`syllabus_id`);

--
-- Indexes for table `rubrics`
--
ALTER TABLE `rubrics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `syllabus_id` (`syllabus_id`);

--
-- Indexes for table `syllabi`
--
ALTER TABLE `syllabi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `syllabus_sections`
--
ALTER TABLE `syllabus_sections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `syllabus_id` (`syllabus_id`);

--
-- Indexes for table `teaching_plan`
--
ALTER TABLE `teaching_plan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `syllabus_id` (`syllabus_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `approvals`
--
ALTER TABLE `approvals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `bibliography`
--
ALTER TABLE `bibliography`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `faculty_info`
--
ALTER TABLE `faculty_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `rubrics`
--
ALTER TABLE `rubrics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `syllabi`
--
ALTER TABLE `syllabi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `syllabus_sections`
--
ALTER TABLE `syllabus_sections`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `teaching_plan`
--
ALTER TABLE `teaching_plan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `approvals`
--
ALTER TABLE `approvals`
  ADD CONSTRAINT `approvals_ibfk_1` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabi` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `bibliography`
--
ALTER TABLE `bibliography`
  ADD CONSTRAINT `bibliography_ibfk_1` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabi` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `faculty_info`
--
ALTER TABLE `faculty_info`
  ADD CONSTRAINT `faculty_info_ibfk_1` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabi` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `rubrics`
--
ALTER TABLE `rubrics`
  ADD CONSTRAINT `rubrics_ibfk_1` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabi` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `syllabi`
--
ALTER TABLE `syllabi`
  ADD CONSTRAINT `syllabi_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `syllabus_sections`
--
ALTER TABLE `syllabus_sections`
  ADD CONSTRAINT `syllabus_sections_ibfk_1` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabi` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `teaching_plan`
--
ALTER TABLE `teaching_plan`
  ADD CONSTRAINT `teaching_plan_ibfk_1` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabi` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
