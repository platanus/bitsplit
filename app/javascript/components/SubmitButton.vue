<template>
  <button
    @click="$emit('do-click')"
    :class="[buttonClass,colormod,hovermod,widthmod]"
    :disabled="fieldDisabled"
  >
    <slot />
  </button>
</template>
<script>
export default {
  name: 'SubmitButton',
  data() {
    return {
      colormod: 'bg-blue-500',
      hovermod: 'hover:bg-blue-700',
      widthmod: 'w-normal',
      buttonClass:
        'text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline'
    }
  },
  props: {
    fieldDisabled: Boolean,
    fieldPlaceholder: String,
    color: String,
    width: String
  },
  mounted: function() {
    if (this.width == 'full') {
      this.widthmod = 'w-full'
    }
    if (this.color == 'secondary') {
      this.colormod = 'bg-indigo-500'
      this.hovermod = 'hover:bg-indigo-700'
    }
  }
}
</script>
