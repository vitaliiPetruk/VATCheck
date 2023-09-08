import {LightningElement, api, wire} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {updateRecord} from 'lightning/uiRecordApi';

import {getRecord} from 'lightning/uiRecordApi';
import COUNTRY from '@salesforce/schema/Quote.Client_Country__c'

import taxRate from '@salesforce/label/c.Tax_Rate';
import Success_Message from '@salesforce/label/c.Success_Message';

import getData from '@salesforce/apex/PresentVatDataController.getVatData';
import updateVatData from '@salesforce/apex/PresentVatDataController.updateVatData';

const columns = [
    {label: 'Country', fieldName: 'country', type: 'Text'},
    {label: 'VAT Rate', fieldName: 'vat', type: 'text'}
];
export default class PresentVatData extends LightningElement {
    @api recordId;

    record;
    data = [];
    columns = columns;
    title = taxRate;
    isLoading = false;

    @wire(getRecord, {recordId: '$recordId', fields: [COUNTRY]})
    wiredRecord(result) {
        this.record = result;
        if (result.data) {
            this.getVatData();
        }
    }

    connectedCallback() {
        this.getVatData();
    }

    getVatData() {
        getData({quoteId: this.recordId})
            .then(result => {
                this.data = [
                    {country: result.country, vat: result.standard + '%'}
                ];
            }).catch(error => {
            console.error('Error fetching data:', error);
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            }));
    }

    async handleClick() {
        this.isLoading = true;
        updateVatData({quoteId: this.recordId})
            .then((result) => {
                this.showToast("Success!", Success_Message, "success");
            })
            .catch(error => {
                this.showToast("Error!", error.message, "error");
            });
        await updateRecord({fields: {Id: this.recordId}}).then(() => {
            this.isLoading = false;
        });
    }
}