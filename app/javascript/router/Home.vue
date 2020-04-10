<template>
  <div>
    <h1>Route: {{ routeName }}</h1>
    <p>Current user: {{ currentUser }}</p>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'

export default {
  name: 'Home',
  data() {
    return {
      routeName: 'home'
    }
  },
  computed: {
    ...mapState('user', ['currentUser'])
  }
}
</script>

<style lang="scss"></style>
