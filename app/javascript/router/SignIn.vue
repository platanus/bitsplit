<template id="full">
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
            <inputLabel fieldFor="password">Contraseña Bitsplit</inputLabel>
            <passwordInput fieldId="password" fieldName="password" v-model="password" />
            <submitButton classmod="bg-blue-500 hover:bg-blue-700" :fieldDisabled="false">Ingresar</submitButton>
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
          })
          .catch(() => {
            console.error('error')
          })
      }
    }
  }
}
</script>
