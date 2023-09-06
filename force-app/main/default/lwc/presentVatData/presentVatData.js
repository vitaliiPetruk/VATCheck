import {LightningElement, api, wire} from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getData from '@salesforce/apex/PresentVatDataController.getVatData';
import updateVatData from '@salesforce/apex/PresentVatDataController.updateVatData';

const columns = [
    {label: 'Country', fieldName: 'country', type: 'Text'},
    {label: 'VAT Rate', fieldName: 'vat', type: 'text'}
];
export default class PresentVatData extends LightningElement {
    @api recordId;
    data = [];
    columns = columns;
    title = 'Tax Rate';

    connectedCallback() {
        this.calloutFromApex();
    }

    calloutFromApex() {
        getData({quoteId: this.recordId})
            .then(result => {
                console.log('result -> ', result);
                this.data = [
                    {country: result.country, vat: result.standard + '%'}
                ];
            }).catch(error => {
            console.error('Error fetching data:', error);
        });
    }

    clickUpdateButton() {
        updateVatData({quoteId: this.recordId})
            .then(() => {
                this.showToast("Success!", "VAT update was successful!", "success");
            })
            .catch(error => {
                this.showToast("Error!", "Some unexpected error", "error");
            });
    }

    showToast(title, message, variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            }));

    }

    handleClick() {
        this.clickUpdateButton();
    }

}
