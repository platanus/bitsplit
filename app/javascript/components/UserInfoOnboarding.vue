<template>
  <div class="flex flex-col justify-between flex-grow">
    <label
      class="txt-field block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2"
      for="grid-last-name"
    >
      Ingresa tu nombre
    </label>
    <textInput
      field-id="userName"
      field-type="text"
      field-name="userName"
      :value="userName"
      v-model="userName"
    />
    <label
      class="txt-field block uppercase tracking-wide text-gray-700 text-xs font-bold my-2"
      for="grid-last-name"
    >
      Ingresa tu Apellido
    </label>
    <textInput
      field-id="userLastName"
      field-type="text"
      field-name="userLastName"
      :value="userLastName"
      v-model="userLastName"
    /><label
      class="txt-field block uppercase tracking-wide text-gray-700 text-xs font-bold mt-4"
      for="grid-last-name"
    >
      Agrega tu foto de perfil
    </label>
    <textInput
      field-id="userPhoto"
      field-type="text"
      field-name="userPhoto"
      :value="userPhoto"
      v-model="userPhoto"
    /><label
      class="txt-field text-center block uppercase tracking-wide text-gray-700 text-xs font-bold mt-4"
      for="grid-last-name"
    >
      Selecciona tu fecha de nacimiento
    </label>
    <DatePicker
      class="mb-6 mt-2"
      min="1930"
      max="2021"
      v-model="selectedDate"
    />
    <SubmitButton :loading="loading" @do-click="handleSubmit()">
      Agregar Información
    </SubmitButton>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
import SubmitButton from '../components/SubmitButton';
import DatePicker from '../components/DatePicker';
import textInput from '../components/Input';

export default {
  name: 'SplitwiseOnBoarding',
  data() {
    return {
      selectedDate: '',
      userName: '',
      userLastName: '',
      userPhoto: '',
      loading: false,
    };
  },
  components: {
    textInput,
    SubmitButton,
    DatePicker,
  },
  methods: {
    ...mapActions('user', ['updateCurrentUser']),
    handleSubmit() {
      const { userName, userLastName, userPhoto, selectedDate } = this;
      this.loading = true;
      this.updateCurrentUser({
        name: userName,
        last_name: userLastName,
        birth_date: selectedDate,
        picture: userPhoto,
      })
        .then(() => {
          this.loading = false;
        })
        .catch(() => {
          this.loading = false;
        });
    },
  },
};
</script>
