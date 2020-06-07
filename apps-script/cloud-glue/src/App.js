import React, { useState, useCallback } from 'react';
import {
  Layout,
  Page,
  FooterHelp,
  Card,
  Link,
  Button,
  FormLayout,
  TextField,
  ChoiceList,
  DatePicker,
  Select,
} from '@shopify/polaris';
import { ImportMinor } from '@shopify/polaris-icons';

export default function App() {
  const [role, setSelectedRole] = useState('');
  const [food, setSelectedFood] = useState('');
  const [email, setEmail] = useState('');
  const [checkboxes, setCheckboxes] = useState([]);
  const [{ month, year }, setDate] = useState({
    month: new Date().getUTCMonth(),
    year: new Date().getUTCFullYear(),
  });

  const handleSubmit = useCallback((value) => {
    value.preventDefault();
    let things = {
      selectedDates: selectedDates,
      month: month,
      year: year,
      food: food,
      role: role,
      email: email,
      checkboxes: checkboxes,
    };

    console.log(JSON.stringify(things));

    google.script.run
      .withSuccessHandler(
        function (msg, element) {
          // Respond to success conditions here.
          console.log('yay: ' + JSON.stringify(msg))
          element.disabled = false;
        })
      .withFailureHandler(
        function (msg, element) {
          // Respond to failure conditions here.
          console.error('sadpanda: ' + JSON.stringify(msg))
          element.disabled = false;
        })
      .withUserObject(this)
      .setDocumentProperties(things);
  });

  const handleSelectRoleChange = useCallback((value) => setSelectedRole(value), []);
  const handleSelectFoodChange = useCallback((value) => setSelectedFood(value), []);
  const handleEmailChange = useCallback((value) => setEmail(value), []);
  const handleMonthChange = useCallback(
    (month, year) => setDate({ month, year }),
    [],
  );
  const handleCheckboxesChange = useCallback(
    (value) => setCheckboxes(value),
    [],
  );

  const primaryAction = { content: 'Save', onAction: handleSubmit };
  const secondaryActions = [{ content: 'Import', icon: ImportMinor }];
  const choiceListItems = [
    { label: 'I like checkboxes', value: 'false' },
  ];

  const [selectedDates, setSelectedDates] = useState({
    start: new Date('Sun Jun 07 2020 00:00:00 GMT-0500 (EST)'),
    end: new Date('Sun Jun 07 2020 00:00:00 GMT-0500 (EST)'),
  });

  const roles = [
    { label: '👑 Administrator', value: 'admin' },
    { label: '👩‍💻 User', value: 'user' },
  ];

  const foods = [
    { label: '🍣 Sushi', value: 'sushi' },
    { label: '🍕 Pizza', value: 'pizza' },
    { label: '🥙 Donair', value: 'donair' },

  ];

  return (
    <Page
      title="🧼 hi, wash ur hands"
      primaryAction={primaryAction}
      secondaryActions={secondaryActions}
    >
      <Layout>
        <Layout.AnnotatedSection
          title="Configuration"
          description="A little form to demonstrate stuff n things"
        >
          <Card sectioned>
            <FormLayout>
              <FormLayout.Group>
                <Select
                  label="Role: "
                  labelInline
                  options={roles}
                  onChange={handleSelectRoleChange}
                  value={role}
                />
                <Select
                  label="Food: "
                  labelInline
                  options={foods}
                  onChange={handleSelectFoodChange}
                  value={food}
                />
              </FormLayout.Group>

              <TextField
                value={email}
                label="Email"
                placeholder="example@email.com"
                onChange={handleEmailChange}
              />

              <DatePicker
                month={month}
                year={year}
                onChange={setSelectedDates}
                onMonthChange={handleMonthChange}
                selected={selectedDates}
              />

              <ChoiceList
                allowMultiple
                choices={choiceListItems}
                selected={checkboxes}
                onChange={handleCheckboxesChange}
              />

              <Button
                primary
                onClick={handleSubmit}
              >Submit</Button>
            </FormLayout>
          </Card>
        </Layout.AnnotatedSection>

        <Layout.Section>
          <FooterHelp>
            For more details on Polaris, visit our{' '}
            <Link url="https://polaris.shopify.com">style guide</Link>.
          </FooterHelp>
        </Layout.Section>
      </Layout>
    </Page>
  );
}