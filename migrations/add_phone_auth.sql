-- Migration: Add Phone Authentication Support
-- Date: 2025-12-03

-- Step 1: Add phone_number field to users table
ALTER TABLE `users`
ADD COLUMN `phone_number` VARCHAR(20) DEFAULT NULL AFTER `email`,
ADD UNIQUE INDEX `idx_phone_number` (`phone_number`);

-- Step 2: Create OTP verification table for phone authentication
CREATE TABLE `phone_otp` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `phone_number` VARCHAR(20) NOT NULL,
  `otp_code` VARCHAR(6) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `expires_at` TIMESTAMP NOT NULL,
  `is_verified` TINYINT(1) DEFAULT 0,
  `attempts` INT(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `idx_phone_otp` (`phone_number`, `otp_code`, `expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Step 3: Add index for faster phone number lookups
ALTER TABLE `users`
ADD INDEX `idx_phone_login` (`phone_number`, `is_active`);
