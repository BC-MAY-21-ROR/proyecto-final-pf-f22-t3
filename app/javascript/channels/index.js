import { createConsumer } from "@rails/actioncable";

window.consumer = createConsumer("/cable");
