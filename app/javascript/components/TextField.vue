<template>
  <p 
    class='block mb-5 font-bold text-gray-700'
    :class="[
      fontSize === 'full' ? 'text-xxl' : 'text-md',
      fontColor === 'secondary' ? 'text-blue-500' : 'text-gray-700'
    ]"
  >
    <slot />
  </p>
</template>

<script>
export default {
  name: 'textField',
  props: {
    fontSize: String,
    fontColor: String
  }
}
</script>