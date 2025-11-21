from marshmallow import Schema, fields, validates, ValidationError
   
   class CalculationSchema(Schema):
       x = fields.Integer(required=True, validate=lambda n: 0 <= n <= 999999)
       y = fields.Integer(required=True, validate=lambda n: 0 <= n <= 999999)
       z = fields.Integer(required=True, validate=lambda n: 0 <= n <= 999999)
       
       @validates_schema
       def validate_sum(self, data, **kwargs):
           total = data['x'] + data['y'] + data['z']
           if total > 2999997:  # 3 * 999999
               raise ValidationError("Sum exceeds maximum allowed value")
