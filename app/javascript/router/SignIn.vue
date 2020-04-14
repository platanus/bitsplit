<template id="full">
  <div id="SignInForm">
    <center>
      <div class="w-full max-w-xs">
        <form
          @submit.prevent="handleSubmit"
          class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4"
        >
          <div class="mb-4">
            <inputLabel fieldName="Email" fieldFor="email" />
            <textInput
              fieldId="email"
              fieldType="text"
              fieldPlaceholder="Email"
              fieldName="email"
              v-model = "email"
            />
          </div>
          <div class="mb-4">
            
            <inputLabel fieldName="Password" fieldFor="password" />
            <passwordInput
              fieldId="password"
              fieldName="password"
              v-model = "password"
            />
            <submitButton :fieldDisabled="false" fieldPlaceholder="Log In" />
          </div>
        </form>
      </div>
    </center>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import textInput from '../components/Input'
import passwordInput from '../components/PasswordInput'
import submitButton from '../components/SubmitButton'
import inputLabel from '../components/InputLabel'

export default {
  name: 'SignIn',
  data() {
    return {
      routeName: 'Sign In',
      email: '',
      password: '',
      loading: false
    }
  },
  components: {
    textInput,
    passwordInput,
    submitButton,
    inputLabel
  },
  computed: {
    ...mapState('user', ['currentUser'])
  },
  methods: {
    ...mapActions('user', ['signIn']),
    handleSubmit(e) {
      const { email, password } = this
      if (email && password) {
        this.signIn({ email, password })
          .then(() => {
            // TODO logger
            console.log('success')
            this.$router.push('/home')
          })
          .catch(() => {
            console.error('error')
          })
      }
    }
  }
}
</script>

<style scoped>
#SignInForm {
  margin-top: 60px;
  margin-bottom: 60px;
}
</style>
