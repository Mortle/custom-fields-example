# README

### Models setup
- `CustomField`: Defines the structure of a custom field, including its name (e.g., "Bio", "Age") and type ("text", "number", "single_select" or "multiple_select").
- `CustomFieldValue`: Stores the actual values of custom fields for each user (fieldable). This model is polymorphic, allowing the extension of custom fields to other models in the future.
- `CustomFieldOption`: For fields requiring selection from predefined options (single or multiple select), this model stores those options.

### Assumptions
- `CustomField` and `CustomFieldOption` are being pre-created and being managed separately. It would be reasonable to utilize another controller for managing these two entities, e.g. `CustomFieldsController` that would accept nested attributes for `custom_field_options`.

### Testing
`PATCH /update` controller action and `CustomFieldValue` model validations are covered with RSpec tests:
- [spec/controllers/v1/users_controller_spec.rb](https://github.com/Mortle/custom-fields-example/blob/main/spec/controllers/v1/users_controller_spec.rb)
- [spec/models/custom_field_value_spec.rb](https://github.com/Mortle/custom-fields-example/blob/main/spec/models/custom_field_value_spec.rb)

### Potential improvements:
- Add custom field validators (e.g. `:numericality` for numbers, `:length` limitations for texts).
- Enhance code styling with a linter like [Rubocop](https://github.com/rubocop/rubocop) or [standardrb](https://github.com/standardrb/standard).
