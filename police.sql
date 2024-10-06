-- Create the police job table
CREATE TABLE IF NOT EXISTS `police_jobs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `grade` INT NOT NULL,
    `duty` BOOLEAN NOT NULL DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create the police job grades table
CREATE TABLE IF NOT EXISTS `police_job_grades` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `job_name` VARCHAR(50) NOT NULL,
    `grade` INT NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `payment` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert default job grades for police
INSERT INTO `police_job_grades` (`job_name`, `grade`, `name`, `payment`) VALUES
('police', 0, 'Cadet', 50),
('police', 1, 'Officer', 100),
('police', 2, 'Sergeant', 150),
('police', 3, 'Lieutenant', 200),
('police', 4, 'Chief', 250);