require("@rails/activestorage").start();

import "trix"
import "flowbite/dist/flowbite.js"
import 'tw-elements';
import "@rails/actiontext";
import "@hotwired/turbo-rails"
import "./packs/back-to-top.js"
import "./packs/mini-profiler-fix.js"
import "./packs/uppy_uploads.js"
import "./packs/direct_upload.js"
import "./packs/metadata_fields.js"



document.addEventListener("turbo:load", e => {

  if ((document.querySelector('meta[name="psj"]').attributes["controller"].value !== "uploads") || ((document.querySelector('meta[name="psj"]').attributes["action"].value !== "new") && (document.querySelector('meta[name="psj"]').attributes["action"].value !== "edit")))
    return

  const addFields = () => {
    fieldCounter++;

    if (!document.getElementById('metadata-form')) {

      let newForm = document.getElementById('metadata-form-template').cloneNode(true);
      newForm.id = 'metadata-form';
      newForm.className = 'grid grid-cols-11 gap-4 container mx-auto mt-0';
      let childFields = newForm.getElementsByTagName("*");

      for (let i = 0; i < childFields.length; i++) {
        let theName = childFields[i].name
        if (theName)
          childFields[i].name = theName + '-' + fieldCounter;
        if (childFields[i].tagName === "INPUT")
          childFields[i].classList.add("metadata")
      }

      let insertHere = document.getElementById('insert-node');
      insertHere.parentNode.insertBefore(newForm, insertHere);
      var form = document.getElementById("metadata-form");

    } else {
      let newForm = document.getElementById('metadata-form-template').cloneNode(true);

      let childFields = newForm.getElementsByTagName("*");

      for (let i = 0; i < childFields.length; i++) {
        let theName = childFields[i].name
        if (theName)
          childFields[i].name = theName + '-' + fieldCounter;
        if (childFields[i].tagName === "INPUT")
          childFields[i].classList.add("metadata")
      }

      var form = document.getElementById("metadata-form");
      let childNodes = newForm.childNodes;
      form.append(...childNodes)

    }
    form.addEventListener('input', handleSubmit);
    // form.addEventListener('change', handleSubmit);


    removeFieldBtns = document.querySelectorAll('#remove-field')

    for (btn of removeFieldBtns) {
      btn.addEventListener('click', removeFields)
      btn.addEventListener('click', handleSubmit)
    }

  }

  const removeFields = (event) => {
    element = event.target.closest('div')
    element.previousElementSibling.remove()
    element.previousElementSibling.remove()
    element.remove()
  }

  // generate JSON from form
  const formToJSON = (elements) =>
    [].reduce.call(
      elements,
      (data, element) => {
        data[element.name] = element.value;
        return data;
      },
      {},
    );

  // modify initial JSON
  const metadataFromJSON = (obj) => {
    let values = Object.values(obj)
    let newObj = []
    // subdivide array
    for (let i = 0; i < values.length; i += 2) {
      const chunk = values.slice(i, i + 2);
      newObj.push(chunk)
    }
    // transpose array
    if (newObj.length !== 0) {
      console.log(newObj)
      newObj = newObj[0].map((_, colIndex) => newObj.map(row => row[colIndex]))
      return arrayToJSONObject(newObj)[0]
    }
    return 0
  }

  const arrayToJSONObject = (arr) => {
    let keys = arr[0];

    let newArr = arr.slice(1, arr.length);

    let formatted = [],
      data = newArr,
      cols = keys,
      l = cols.length;
    for (let i = 0; i < data.length; i++) {
      let d = data[i],
        o = {};
      for (let j = 0; j < l; j++)
        o[cols[j]] = d[j];
      formatted.push(o);
    }
    return formatted;
  }

  const removeEmpty = (obj) => {
    Object.keys(obj).forEach((k) => (obj[k] == "") && (k == "") && delete obj[k]);
    return obj;
  };

  const convertKeysToLowerCase = (obj) => {
    let output = {};
    for (i in obj) {
      if (Object.prototype.toString.apply(obj[i]) === '[object Object]') {
        output[i.toLowerCase()] = ConvertKeysToLowerCase(obj[i]);
      } else if (Object.prototype.toString.apply(obj[i]) === '[object Array]') {
        output[i.toLowerCase()] = [];
        output[i.toLowerCase()].push(ConvertKeysToLowerCase(obj[i][0]));
      } else {
        output[i.toLowerCase()] = obj[i];
      }
    }
    return output;
  }

  const handleSubmit = (event) => {

    var mDataForm = document.getElementById("metadata-form")
    mDataFormInputs = Array.from(mDataForm.closest('form').elements).filter(e => e.classList.contains("metadata"))
    const data = formToJSON(mDataFormInputs);
    let jsonData = removeEmpty(data)
    jsonData = metadataFromJSON(jsonData)
    jsonData = convertKeysToLowerCase(jsonData)
    jsonData = JSON.stringify(jsonData, null, 2)

    document.getElementById("json-hidden-pre").textContent = jsonData.toString();
    document.getElementById("json-hidden-input").value = jsonData.toString();
  }

  let fieldCounter = 0;
  addFields()
  let addFieldBtn = document.getElementById("add-fields")
  addFieldBtn.addEventListener("click", addFields);
  addFieldBtn.addEventListener('click', handleSubmit)
})
