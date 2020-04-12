<template>
  <div >
    <app-header>
    </app-header>
    <div id="content">
    <h1>Route: {{ routeName }}</h1>
    <p>Current user: {{ currentUser }}</p>
    <button @click="signOut">Log Out</button>
    </div>
  <app-footer>
  </app-footer>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'

import Header from '../components/Layout/Header'
import Footer from '../components/Layout/Footer'

export default {
  components: {
    'app-header': Header,
    'app-footer': Footer
  },
  name: 'Home',
  data() {
    return {
      routeName: 'Home',
      signInRoute: 'sign-in',
      signUpRoute: 'sign-up'
    }
  },
  computed: {
    ...mapState('user', ['currentUser'])
  },
  methods: {
    ...mapActions('user', ['signOut']),
    handleLogOut() {
      this.logOut().then(() => {
        this.$router.push('/')
      })
    }
  }
}
</script>

<style>
#content {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
  margin-bottom: 60px;
}
</style>