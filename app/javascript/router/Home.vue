<template>
  <div>
    <div v-if= !budaSignedIn >
      <BudaAlert></BudaAlert>
    </div>
    <h1>Route: {{ routeName }}</h1>
    <div v-if= currentUser >
      <p>Current user: {{ currentUser.email }}</p>
      <p>API_KEY: {{ currentUser.api_key }}</p>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'
import BudaAlert from 'components/BudaAlert.vue'
export default {
  name: 'Home',
  data() {
    return {
      routeName: 'home'
    }
  },
  components: {
    BudaAlert
  },
  computed: {
    ...mapState('user', ['currentUser']),
    ...mapGetters('user', ['budaSignedIn'])
  }
}
</script>

<style lang="scss"></style>