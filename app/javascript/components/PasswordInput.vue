<template>
  <input
    class="shadow appearance-none border border-red-500 rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"
    :id="fieldId"
    type="password"
    placeholder= "******************"
    :name="fieldName"
    :value="value"
    @input="$emit('update', $event.target.value)"
  />
</template>
<script>
export default {
  name: 'PasswordForm',
  props: {
    value: String,
    fieldId: String,
    fieldName: String
  },
  model: {
    prop: 'value',
    event: 'update'
  }
}
</script>
