<template>
  <p 
    class='block mb-5 font-bold text-gray-700'
    :class="[
      fontsize === 'full' ? 'text-xxl' : 'text-md',
      textcolor === 'secondary' ? 'text-indigo-500' : 'text-gray-700'
    ]"
  >
    <slot />
  </p>
</template>

<script>
export default {
  name: 'textField',
  props: {
    fontsize: String,
    textcolor: String
  }
}
</script>