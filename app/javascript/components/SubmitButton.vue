<template>
  <button @click="$emit('do-click')"
    :class= [buttonClass,colormod,hovermod,widemod]
    :disabled= fieldDisabled 
  >
    {{ fieldPlaceholder }}
  </button>
</template>
<script>
export default {
  name: 'SubmitButton',
  data () {
    return {
      colormod: 'bg-blue-500',
      hovermod: 'hover:bg-blue-700',
      widemod: 'w-normal',
      buttonClass: 'text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline'
    }
  },
  props: {
    fieldDisabled: Boolean,
    fieldPlaceholder: String,
    color: String,
    wide: String
  },
  mounted: function() {
    if (this.wide == 'full') {
      this.widemod = 'w-full'
    }
    if (this.color == 'secondary') {
      this.colormod = 'bg-indigo-500'
      this.hovermod = 'hover:bg-indigo-700'
    }
  }
}
</script>
