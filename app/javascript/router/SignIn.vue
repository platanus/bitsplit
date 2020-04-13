<template id="full">
  <div id="SignInForm">
    <center>
      <div class="w-full max-w-xs">
        <form
          @submit.prevent="handleSubmit"
          class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4"
        >
          <div class="mb-4">
            <label
              class="block text-gray-700 text-sm font-bold mb-2"
              for="email"
            >
              Email
            </label>
            <inputForm
              fieldId="email"
              fieldType="text"
              fieldPlaceholder="Email"
              fieldName="email"
              v-model = "email"
            />
          </div>
          <div class="mb-4">
            <label
              class="block text-gray-700 text-sm font-bold mb-2"
              for="password"
            >
              Password
            </label>
            <passwordInput
              fieldId="password"
              fieldPlaceholder="******************"
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
import inputForm from '../components/Input'
import passwordInput from '../components/PasswordInput'
import submitButton from '../components/SubmitButton'

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
    inputForm,
    passwordInput,
    submitButton
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
