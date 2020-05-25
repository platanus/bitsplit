<template>
  <div class="mt-16">
    <center>
      <div class="w-full max-w-xs ">
        <div class="flex content-start mb-8 ">
          <router-link :to="signInRoute">
            <img
              src="assets/left-arrow.svg"
              class="mr-2"
              align="top"
            >
          </router-link>
          <router-link :to="signInRoute">
            <p class="txt-field">
              Volver
            </p>
          </router-link>
        </div>
        <img
          src="assets/bitsplit-logo.svg"
          class="mb-4"
          align="top"
        >

        <p class="txt-field mb-8">
          Crea tu cuenta, es fácil y rápido
        </p>
        <form
          @submit.prevent="handleSubmit"
          class="  pt-4 pb-8 mb-4"
        >
          <div class="mb-8">
            <textInput
              field-id="email"
              field-type="text"
              field-placeholder="Ingresa tu correo"
              field-name="email"
              v-model="email"
            />
          </div>
          <div class="mb-4">
            <passwordInput
              field-id="password"
              field-name="password"
              field-placeholder="Crea tu contraseña"
              v-model="password"
            />
            <passwordInput
              field-id="confirm_password"
              field-name="confirm_password"
              field-placeholder="Repite tu contraseña"
              v-model="confirm_password"
            />
          </div>
          <div class="mb-8">
            <checkBox
              field-text="Acepto los términos de privacidad"
              v-model="checkboxField"
            />
          </div>
          <submitButton :loading="signUpLoading">
            Crear Cuenta
          </submitButton>
        </form>
      </div>
    </center>
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import textInput from '../components/Input';
import passwordInput from '../components/PasswordInput';
import submitButton from '../components/SubmitButton';
import checkBox from '../components/Checkbox';

export default {
  name: 'SignUp',
  data() {
    return {
      routeName: 'SignUp',
      email: '',
      password: '',
      confirm_password: '',
      signInRoute: 'sign-in',
      checkboxField: false,
    };
  },
  components: {
    textInput,
    passwordInput,
    submitButton,
    checkBox,
  },
  computed: {
    ...mapState('user', ['currentUser', 'signUpLoading']),
  },
  methods: {
    ...mapActions('user', ['signUp']),
    handleSubmit() {
      const { checkboxField, email, password, confirm_password } = this;
      if (checkboxField && email && password && password === confirm_password) {
        // TODO logger
        this.signUp({ email, password })
          .then(() => {
            // TODO logger
            this.$router.push('/sign-in');
          })
          .catch(err => {
            console.error(err);
          });
      }
    },
  },
};
</script>
