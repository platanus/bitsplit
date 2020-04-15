<template>
  <label class="block text-gray-700 text-sm font-bold mb-2" for= fieldFor >
    {{ fieldName }}
  </label>
</template>
<script>
export default {
  name: 'inputLabel',
  props: {
    fieldName: String, 
    fieldFor: String
  }
}
</script>
