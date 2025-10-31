# Coupon System Setup Guide

## ✅ Fixed Issues

The coupon validation was accepting incorrect codes like "CLEAN20DD" when only "CLEAN20" exists. 

**Fixes Applied:**
1. Added input sanitization (trim + uppercase)
2. Added detailed validation logging
3. Added empty code check
4. Better error messages

## 🔧 Required Supabase Setup

### 1. Ensure Coupon Codes are UPPERCASE

Run this SQL in Supabase SQL Editor to update existing codes:

```sql
-- Update all coupon codes to UPPERCASE
UPDATE coupons
SET code = UPPER(code);

-- Add constraint to ensure future codes are uppercase
ALTER TABLE coupons
ADD CONSTRAINT code_uppercase_check
CHECK (code = UPPER(code));
```

### 2. Create the increment_coupon_use Function

```sql
-- SQL function to increment coupon usage count
CREATE OR REPLACE FUNCTION increment_coupon_use(coupon_code TEXT)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE coupons
  SET used_count = used_count + 1
  WHERE code = UPPER(coupon_code);
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION increment_coupon_use(TEXT) TO authenticated;
```

### 3. Verify Your Coupons Table Schema

```sql
-- Check if table exists and has correct structure
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'coupons'
ORDER BY ordinal_position;
```

Required columns:
- `id` (uuid)
- `code` (text) - UPPERCASE
- `description` (text)
- `discount_percent` (numeric)
- `valid_from` (timestamptz)
- `valid_until` (timestamptz)
- `max_uses` (integer)
- `used_count` (integer, default: 0)
- `active` (boolean, default: true)
- `created_at` (timestamptz)

## 🧪 Testing

After setup, test with these scenarios:

1. **Valid coupon (exact match):**
   - Input: "CLEAN20" → ✅ Should work
   - Input: "clean20" → ✅ Should work (auto-uppercase)
   - Input: " CLEAN20 " → ✅ Should work (auto-trim)

2. **Invalid coupons:**
   - Input: "CLEAN20DD" → ❌ Should fail (not found)
   - Input: "INVALID" → ❌ Should fail (not found)
   - Input: "" → ❌ Should fail (empty)

3. **Expired coupons:**
   - Coupon with `valid_until` in the past → ❌ Should fail
   - Coupon with `used_count >= max_uses` → ❌ Should fail
   - Coupon with `active = false` → ❌ Should fail

## 📝 Console Logs

You should see these logs when testing:

```
🔍 Validating coupon: CLEAN20
✅ Coupon validated: CLEAN20 - 20% discount
```

Or for invalid:

```
🔍 Validating coupon: CLEAN20DD
❌ Coupon "CLEAN20DD" not found or expired
```

## 🎯 Next Steps

1. Run the SQL scripts above in Supabase
2. Test coupon validation in your app
3. Check console logs to verify correct behavior
4. Integrate with your cart UI
