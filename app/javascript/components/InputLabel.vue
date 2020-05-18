<template>
  <label
    class="block text-gray-700 text-sm font-bold mb-2"
    for="fieldFor"
  >
    <slot />
  </label>
</template>
<script>
export default {
  name: 'InputLabel',
  props: {
    fieldName: String,
    fieldFor: String,
  },
};
</script>
