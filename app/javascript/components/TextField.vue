<template>
  <div :class="divclass">
    <p :class= [pclass,pcolormod]>
      {{ textvalue1 }}
    </p>
    <a :class="pclass" :href="href">
      {{ linktext }}
    </a>
    <p :class="pclass">
      {{ textvalue2 }}
    </p>
  </div>
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
  },
  props: {
    textvalue1: {
      type: String,
      default: null
    },
    textvalue2: {
      type: String,
      default: null
    },
    linktext: {
      type: String,
      default: null
    },
    href: {
      type: String,
      default: null
    }
  },
}
</script>