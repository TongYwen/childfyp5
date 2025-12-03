# Phone Authentication Setup Guide

This document explains how to set up and use phone-based authentication in the ChildGrowth Insights application.

## Overview

The application now supports two authentication methods for parents:
- **Email & Password** (traditional method)
- **Phone Number & OTP** (new SMS-based method)

## Features

- **Phone Registration**: Parents can create accounts using their phone number
- **Phone Login**: Passwordless login using SMS OTP codes
- **OTP Verification**: 6-digit codes valid for 10 minutes
- **Security**: Maximum 3 verification attempts per OTP
- **International Support**: Accepts phone numbers in international format

## Database Setup

### 1. Run the Migration

Execute the SQL migration to add phone authentication support:

```bash
mysql -u your_username -p your_database < migrations/add_phone_auth.sql
```

Or manually run the SQL commands:

```sql
-- Add phone_number field to users table
ALTER TABLE `users`
ADD COLUMN `phone_number` VARCHAR(20) DEFAULT NULL AFTER `email`,
ADD UNIQUE INDEX `idx_phone_number` (`phone_number`);

-- Create OTP verification table
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

-- Add index for faster phone lookups
ALTER TABLE `users`
ADD INDEX `idx_phone_login` (`phone_number`, `is_active`);
```

## Twilio Configuration

### 2. Sign Up for Twilio

1. Create a free Twilio account at https://www.twilio.com/try-twilio
2. Get your **Account SID** and **Auth Token** from the Twilio Console
3. Get a **Twilio Phone Number** (with SMS capabilities)

### 3. Configure Environment Variables

Add the following to your `.env` file:

```env
# Twilio SMS Configuration
TWILIO_ACCOUNT_SID=your_account_sid_here
TWILIO_AUTH_TOKEN=your_auth_token_here
TWILIO_PHONE_NUMBER=+1234567890
```

**Example:**
```env
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your_auth_token_here
TWILIO_PHONE_NUMBER=+15551234567
```

### 4. Install Dependencies

Install the required Python packages:

```bash
pip install -r requirements.txt
```

This will install:
- `twilio` - Twilio Python SDK for sending SMS
- `phonenumbers` - Phone number validation library

## Usage

### Phone Registration Flow

1. User visits `/register/select`
2. Selects "Parent (Phone)" option
3. Enters name, phone number, and password
4. Receives 6-digit OTP via SMS
5. Enters OTP to verify and create account

### Phone Login Flow

1. User visits `/login` and clicks "Login with Phone Number"
2. Or visits `/login/phone` directly
3. Enters phone number in international format
4. Receives 6-digit OTP via SMS
5. Enters OTP to login

### Phone Number Format

Phone numbers must be in **international format** with country code:

✅ **Valid formats:**
- `+60123456789` (Malaysia)
- `+6591234567` (Singapore)
- `+15551234567` (USA)

❌ **Invalid formats:**
- `0123456789` (missing country code)
- `123456789` (incomplete)
- `+60 12-345 6789` (contains spaces/dashes - will be validated but should avoid)

## Security Features

### OTP Security

- **Expiration**: OTP codes expire after 10 minutes
- **Attempt Limit**: Maximum 3 verification attempts per OTP
- **One-time Use**: OTP can only be verified once successfully
- **Database Tracking**: All OTP attempts are logged

### User Account Security

- **Unique Phone Numbers**: Each phone number can only be registered once
- **Password Required**: Phone-registered accounts still require a strong password
- **Session Management**: Same security as email-based accounts
- **Account Status**: Respects `is_active` and `deleted_at` status

## Testing

### Development Mode (Without Twilio)

If Twilio credentials are not configured, the system will:
- Print OTP codes to console/logs
- Return `False` from `send_otp_sms()`
- Show error message to user

For testing, check the application logs:
```
Twilio client not configured. OTP: 123456
```

### Production Mode (With Twilio)

In production with Twilio configured:
- SMS will be sent to user's phone
- OTP codes are not logged
- Success/failure messages logged with Twilio SID

## API Routes

| Route | Method | Description |
|-------|--------|-------------|
| `/register/phone` | GET, POST | Phone-based registration |
| `/login/phone` | GET, POST | Phone-based login with OTP |
| `/login` | GET, POST | Updated with phone login link |
| `/register/select` | GET | Updated with phone registration option |

## Database Schema

### Users Table (Updated)

```sql
CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,  -- NEW
  `password` varchar(255) NOT NULL,
  `role` enum('parent','admin') NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `protected_from_deletion` tinyint(1) DEFAULT 0,
  `inactive_warning_sent` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `deletion_reason` varchar(255) DEFAULT NULL,
  UNIQUE KEY `idx_phone_number` (`phone_number`)  -- NEW
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### Phone OTP Table (New)

```sql
CREATE TABLE `phone_otp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(20) NOT NULL,
  `otp_code` varchar(6) NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NOT NULL,
  `is_verified` tinyint(1) DEFAULT 0,
  `attempts` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_phone_otp` (`phone_number`,`otp_code`,`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## Troubleshooting

### OTP Not Received

1. Check Twilio credentials are correct in `.env`
2. Verify phone number format includes country code
3. Check Twilio account balance
4. Review Twilio console for delivery status
5. Check application logs for errors

### Invalid Phone Number Error

- Ensure phone number includes country code (e.g., `+60`)
- Use international format without spaces or dashes
- Verify the number is valid for the country

### Database Errors

- Ensure migration has been run
- Check `phone_number` column exists in `users` table
- Verify `phone_otp` table exists
- Check database user has necessary permissions

## Future Enhancements

Potential improvements for phone authentication:

- [ ] SMS rate limiting to prevent abuse
- [ ] Multiple phone numbers per account
- [ ] Phone number verification for existing accounts
- [ ] SMS templates customization
- [ ] Alternative SMS providers (besides Twilio)
- [ ] Phone number change/update functionality
- [ ] Two-factor authentication (2FA) via SMS

## Support

For issues or questions:
1. Check application logs for error messages
2. Review Twilio console for SMS delivery status
3. Verify all configuration steps were completed
4. Check database migration was successful

## License

Part of ChildGrowth Insights application.
