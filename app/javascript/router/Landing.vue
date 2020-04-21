<template>
  <div>
    <p>Route: {{ routeName }}</p>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
export default {
  name: 'Landing',
  data() {
    return {
      routeName: 'Landing'
    }
  },
  computed: {
    ...mapGetters('user', ['signedIn'])
  }
}
</script>

<style lang="scss"></style>