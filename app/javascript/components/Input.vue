<template>
  <input
    class="txt-input"
    :class="[
      'appearance-none border rounded w-full py-2 px-3  leading-tight focus:outline-none focus:shadow-outline',
      classmod,
    ]"
    :id="fieldId"
    :type="fieldType"
    :placeholder="fieldPlaceholder"
    :name="fieldName"
    :value="value"
    min="0"
    step="0.000001"
    @input="$emit('update', $event.target.value)"
  />
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
