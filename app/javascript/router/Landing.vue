<template>
  <SignIn/>
</template>

<script>
import { mapGetters } from 'vuex'
import LinkButton from '../components/LinkButton'
import SignIn from './SignIn'

export default {
  name: 'Landing',
  data() {
    return {
      routeName: 'Landing'
    }
  },
  components: {
    LinkButton,
    SignIn
  },
  computed: {
    ...mapGetters('user', ['signedIn'])
  }
}
</script>

<style lang="scss"></style>
