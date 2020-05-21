<template>
  <input
    class = "txt-input"
    :class= "[classmod, 'appearance-none border rounded w-full py-2 px-3  leading-tight focus:outline-none focus:shadow-outline']"
    :id="fieldId"
    :type="fieldType"
    :placeholder="fieldPlaceholder"
    :name="fieldName"
    :value="value"
    @input="$emit('update', $event.target.value)"
  >
</template>
<script>
export default {
  name: 'InputForm',
  props: {
    value: String,
    fieldId: String,
    fieldType: String,
    fieldPlaceholder: String,
    fieldName: String,
    classmod: {
      type: String,
      default: '',
    },
  },
  model: {
    prop: 'value',
    event: 'update',
  },
};
</script>
