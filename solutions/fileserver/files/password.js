const passwordValidator = require("password-validator");

const schema = new passwordValidator();
schema
  .is()
  .min(12) // Minimum 12 characters
  .has()
  .uppercase() // Uppercase required
  .has()
  .lowercase() // Lowercase required
  .has()
  .digits(2) // At least 2 digits
  .has()
  .symbols() // Special character required
  .has()
  .not()
  .spaces() // No spaces
  .is()
  .not()
  .oneOf(["Password123", "Admin123"]); // Blacklist
