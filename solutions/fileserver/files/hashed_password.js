const bcrypt = require('bcrypt');
   const saltRounds = 12;
   
   // During registration
   const hashedPassword = await bcrypt.hash(plainPassword, saltRounds);
   
   // During verification
   const match = await bcrypt.compare(inputPassword, hashedPassword);
