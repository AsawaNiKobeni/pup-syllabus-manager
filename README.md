# PUP Syllabus Manager

## Setup

1. Clone this repo: 
   git clone https://github.com/yourusername/pup-syllabus-manager.git
2. Copy folder to XAMPP `htdocs/`
3. Start XAMPP (Apache + MySQL)
4. Import `syllabus_db.sql` into phpMyAdmin
5. Update `api.php` with database credentials

   $db_host = 'localhost';
   $db_user = 'root';   // default for XAMPP
   $db_pass = '';       // default is empty
   $db_name = 'syllabus_db';
7. Open `view_courses.html` in browser via localhost
