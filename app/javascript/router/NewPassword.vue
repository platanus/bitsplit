<template>
  <div
    class="items-center h-screen w-2/3 m-auto bg-primary p-12 mt-24 text-center"
  >
    <text-field font-size="full">
      {{ this.pageTitle }}
    </text-field>
    <text-field>
      {{ this.email }}
    </text-field>
    <form
      @submit.prevent="handleSubmit"
      class="bg-primary rounded pt-6 pb-8 mb-4"
    >
      <div class="mb-4">
        <inputLabel>
          Ingresa tu Contraseña
        </inputLabel>
        <passwordInput
          field-id="passwordOne"
          field-name="passwordOne"
          field-placeholder="Contraseña"
          v-model="passwordOne"
        />
      </div>
      <div class="mb-4">
        <inputLabel>
          Repite tu Contraseña
        </inputLabel>
        <passwordInput
          field-id="passwordTwo"
          field-name="passwordTwo"
          field-placeholder="Contraseña"
          v-model="passwordTwo"
        />
      </div>
      <submitButton width="full">
        Ingresar
      </submitButton>
    </form>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
import textField from '../components/TextField';
import passwordInput from '../components/PasswordInput';
import submitButton from '../components/SubmitButton';
import inputLabel from '../components/InputLabel';

export default {
  name: 'NewPassword',
  data() {
    return {
      routeName: '',
      passwordOne: '',
      passwordTwo: '',
      recoveryToken: '',
      email: '',
    };
  },
  components: {
    textField,
    passwordInput,
    submitButton,
    inputLabel,
  },
  created() {
    this.recoveryToken = this.$router.history.current.query.token;
    this.email = this.$router.history.current.query.email;
    this.routeName = this.$router.history.current.path;

    if (!this.email || !this.recoveryToken) {
      this.$router.push('/');
    }
  },
  computed: {
    pageTitle() {
      return this.routeName === '/new-account'
        ? 'Crea tu cuenta'
        : 'Recupera tu cuenta';
    },
  },
  methods: {
    ...mapActions('user', ['passwordRecovery']),
    handleSubmit() {
      const { recoveryToken, email, passwordOne, passwordTwo } = this;

      return this.passwordRecovery({
        recoveryToken,
        email,
        passwordOne,
        passwordTwo,
      })
        .then(() => {
          this.$router.push('/');
        })
        .catch(err => {
          console.error(err);
        });
    },
  },
};
</script>

<style lang="scss"></style>
