# Project Tags

Each control add-in's code is wrapped in `//JOA00X+` / `//JOA00X-` comment
markers, matching the tags below. Use them to quickly locate all the files
involved in a given feature.

## JOA001 — Countries Chart

Google Charts geographic chart showing items by country.

The "Item List" page gets an action, "Item per countries", that opens a page
listing all items; selecting one shows which countries it has been sold to.

## JOA002 — Pie Chart

Google Charts pie chart showing the percentage of open/released sales orders.

The "Sales Order List" page gets a pie chart in the first FactBox area,
showing the percentage of open vs. released orders.

## JOA003 — Carousel

Bootstrap carousel control add-in that displays images on the "Customer List"
page, with basic interaction.

## JOA004 — Drag and Drop *(experimental)*

A box that lets users drop JSON files to create items.

On the "Item List" page, the first FactBox area lets users drop JSON files;
AL code then uses that data to create one or more items.

## JOA005 — Screen Recorder

Records the screen and lets the user download the resulting video.

## JOA006 — Customer Notes

Adds the ability to create notes for each customer.

The "Customer List" and "Customer Card" pages get two actions: one to create
a note for the selected customer (using a JavaScript-based rich text editor),
and one to list existing notes, where each can be viewed and edited.

This example also implements a "No. Series" for the notes, so a few
supporting tables/pages exist solely for that purpose.
