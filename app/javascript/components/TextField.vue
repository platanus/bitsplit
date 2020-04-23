<template>
  <p :class= [divclass,pclass,pcolormod]>
      <slot></slot>
  </p>
</template>

<script>
export default {
  name: 'textField',
  data() {
    return {
      divclass: "block mb-5",
      pclass: "text-sm font-bold",
      pcolormod: "text-gray-700 "
    }
  }
}
</script>