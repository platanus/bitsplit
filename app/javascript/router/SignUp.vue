<template>
  <div class="mt-16">
    <center>
      <div class="w-full max-w-xs">
        <form @submit.prevent="handleSubmit" class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
          <div class="mb-4">
            <inputLabel fieldFor="email">Email</inputLabel>
            <textInput
              fieldId="email"
              fieldType="text"
              fieldPlaceholder="Email"
              fieldName="email"
              v-model="email"
            />
          </div>
          <div class="mb-4">
            <inputLabel fieldFor="password">Password</inputLabel>

            <passwordInput fieldId="password" fieldName="password" v-model="password" />
            <inputLabel fieldFor="password">Repeat your password</inputLabel>
            <passwordInput
              fieldId="confirm_password"
              fieldName="confirm_password"
              v-model="confirm_password"
            />
          </div>
          <submitButton :loading="signUpLoading">Sign Up</submitButton>
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
  name: 'SignUp',
  data() {
    return {
      routeName: 'SignUp',
      email: '',
      password: '',
      confirm_password: ''
    }
  },
  components: {
    textInput,
    passwordInput,
    submitButton,
    inputLabel
  },
  computed: {
    ...mapState('user', ['currentUser','signUpLoading'])
  },
  methods: {
    ...mapActions('user', ['signUp']),
    handleSubmit(e) {
      const { email, password, confirm_password } = this
      // TODO logger
      if (email && password && password === confirm_password) {
        // TODO logger
        this.signUp({ email, password })
          .then(() => {
            // TODO logger
            console.log('success')
          })
          .catch(err => {
            console.error(err)
          })
      }
    }
  }
}
</script>
