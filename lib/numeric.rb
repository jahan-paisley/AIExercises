# Numeric.class_eval do
#   # original_times = instance_method(:^)
#   define_method(:^) do |other|
#     return self ** other
#
#   end
# end
#
# Fixnum.class_eval do
#   # original_times = instance_method(:^)
#   define_method(:^) do |other|
#     return  self **other
#   end
# end