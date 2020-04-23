<template>
  <div id="budaSignInForm">
    <center>
      <div class="w-full max-w-xs">
        <form @submit.prevent="handleSubmit">
          <div>
            <textField>
              Ingresa el API_KEY y API_SECRET de tu cuenta Buda. Puedes acceder a ellos en tu perfil de <a href="https://www.buda.com">www.buda.com</a>
            </textField>
          </div>
          <div>
            <inputLabel fieldName="API_KEY">key</inputLabel>
            <passwordInput fieldId="api_key" fieldName="api_key" v-model="api_key" />
          </div>
          <div>
            <inputLabel fieldName="API_SECRET">api_secret</inputLabel>
            <passwordInput fieldId="api_secret" fieldName="api_secret" v-model="api_secret" />
          </div>
          <div>
            <inputLabel fieldFor="password">Confirma tu contraseña Bitsplit</inputLabel>
            <passwordInput fieldId="password" fieldName="password" v-model="password" />
          </div>
          <div>
            <submitButton :fieldDisabled="false">Sincronizar Buda</submitButton>
          </div>
        </form>
      </div>
    </center>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import textInput from '../components/Input.vue'
import passwordInput from '../components/PasswordInput'
import submitButton from '../components/SubmitButton'
import inputLabel from '../components/InputLabel'
import textField from '../components/TextField'

export default {
  name: 'BudaForm',
  data() {
    return {
      routeName: 'BudaForm',
      api_key: '',
      api_secret: '',
      password: ''
    }
  },
  components: {
    textInput,
    passwordInput,
    submitButton,
    inputLabel,
    textField
  },
  computed: {
    ...mapState('user', ['currentUser'])
  },
  methods: {
    ...mapActions('user', ['budaSignIn']),
    handleSubmit(e) {
      const { api_key, api_secret, password } = this
      if (api_key && api_secret && password) {
        const { email, authentication_token } = this.currentUser
        this.budaSignIn({
          api_key,
          api_secret,
          password,
          email,
          authentication_token
        })
          .then(() => {
            console.log('success')
            this.$router.push('/home')
          })
          .catch(err => {
            console.error(err)
          })
      }
    }
  }
}
</script>

<style scoped>
#budaSignInForm {
  margin-top: 60px;
  margin-bottom: 60px;
}
</style>