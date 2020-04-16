<template>
  <div id="budaSignInForm">
    <center>
      <div class="w-full max-w-xs">
        <div>
          <p class="block text-gray-700 text-sm font-bold mb-5">¡Ya estás conectado a una cuenta Buda! ¿Qué desear hacer?</p>
        </div>
        <div class=inline>
          <div class="pb-6">
            <bigButton @do-click="change('BudaForm')" :fieldDisabled="false" fieldPlaceholder="Actualizar Keys" />
          </div>
          <div class="pb-6">
            <bigButton @do-click="change('BudaLogoutForm')" :fieldDisabled="false" fieldPlaceholder="Desconectar Buda" />
          </div>
        </div>
      </div>
    </center>
  </div>
</template>

<script>
import { mapActions, mapState, mapMutations } from 'vuex'
import textInput from '../components/Input.vue'
import passwordInput from '../components/PasswordInput'
import submitButton from '../components/SubmitButton'
import bigButton from '../components/BigButton'
import inputLabel from '../components/InputLabel'

export default {
  name: 'BudaPerfil',
  data() {
    return {
      routeName: 'BudaPerfil',
      api_key: '',
      api_secret: '',
      password: '',
    }
  },
  components: {
    textInput,
    passwordInput,
    submitButton,
    inputLabel,
    bigButton
  },
  methods: {
    ...mapActions('user', ['changePerfilComp']),
    change(form) {
      localStorage.setItem('currentComponent',form)
      this.changePerfilComp(form)
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