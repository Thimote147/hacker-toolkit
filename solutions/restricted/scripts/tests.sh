# Tests unitaires avec fuzzing
   import hypothesis
   from hypothesis import given, strategies as st
   
   @given(
       x=st.integers(min_value=0, max_value=999999),
       y=st.integers(min_value=0, max_value=999999),
       z=st.integers(min_value=0, max_value=999999)
   )
   def test_calculate_no_crash(x, y, z):
       response = client.post('/calculate', data={'x': x, 'y': y, 'z': z})
       assert response.status_code in [200, 400]  # OK ou Bad Request, jamais 500
