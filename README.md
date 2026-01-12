| Autor | Fecha de Creación | Fecha de Edición | Versión |
| ------------- | ------------- | ------------- | ------------- |
| Pablo Lacioppa | 08-01-2026  | 08-01-2026 | 0.1 |

<br/>

## 1. INTRODUCTION

This repository contains a solution called EADeliverables, whose structure is primarily based on three macro-enabled Excel spreadsheets, evenly distributed across three internal projects: _CoreDeliverables_, _OperationalDeliverables_, and _DecisionDeliverables_. Each of them is located in the /Files directory of its corresponding project and, taken together, they conceptually constitute what I have come to call: the EA Assistance Framework for Small and Medium-Sized Enterprises. 

Additionally, the remaining files included in each of the previously mentioned modules are intended to reflect the extended functionalities implemented through macros within the spreadsheets, thus enabling agile visualization of the source code used. These files do not impact the actual execution of the macros; rather, they simply represent a copy of the code embedded within each Excel file. Consequently, any modification made to them will have no practical effect on the resulting outputs.

The solution also includes a fourth project named _EASummary_, whose purpose is to host auxiliary files that assist the user in identifying and completing the information required by the three main modules. At present, the only available content is a file called EASummary, whose usage will be addressed during the execution of the process.

Regarding the process itself, it refers specifically to the mechanism by which the three aforementioned spreadsheets are used to conceptually understand the organization’s structure and operation, as well as to identify its current challenges and the risks that may affect the future achievement of its objectives.
As a result, sufficient information will be obtained to diagnose:
 - deficiencies,
 - overloads,
 - inconsistencies in decision-making,
 - ack of governance,
 - misalignments between business strategy and execution,
 - overlapping roles and responsibilities,
 - unforeseen costs,
 - lack of preparedness for the incorporation of Artificial Intelligence into business processes,
 - improperly used IT tools.
   
It is important to clarify that this Framework is **not** designed to automatically generate a diagnosis of the problems or potential issues affecting the organization. Instead, its primary purpose is to **collect and highlight** information. The interpretation of results, as well as the formulation of concrete proposals to correct the current course, remains the responsibility of each architect, manager, or operations director who reviews these spreadsheets or defines corrective measures.
Although some modules include legends and visual indicators that support rapid diagnosis and decision-making, a comprehensive and holistic analysis of the collected information is strongly recommended before making changes to organizational components.

<br/>

## 2. PROJECT PERSPECTIVE

For those already familiar with general concepts of Enterprise Architecture (some of which have been implicitly referenced when outlining the diagnostic elements), TOGAF, or the Zachman Framework, all the necessary information to begin using this framework has already been provided — and I encourage you to do so.

For those who wish to gain a deeper understanding of the internal composition of the modules and the proposed working methodology, the following section describes the perspective upon which this tool is based. While the framework includes nuances that could be associated with the Zachman Framework—such as structuring modules around the key questions what…?, why…?, and how…?—the core of the project is inspired by the analysis presented by Eric Jager in his book _Getting Started with Enterprise Architecture_<sup>1</sup>.

The author effectively explains how to apply TOGAF from a pragmatic standpoint, focused on the fundamental needs of an organization. For those unfamiliar with the term, TOGAF is both a standard<sup>2</sup> and a methodology created by The Open Group in 1995 with the purpose of organizing architectural work within large organizations. Today, many major companies and government agencies use it effectively, achieving increased robustness and interoperability in their IT processes.

This framework adopts these concepts in a flexible manner, without adhering strictly to them. The objective remains the same: to promote tools that help establish Enterprise Architecture (EA) practices within an organization as a working discipline. While Eric Jager successfully constructs this approach in his book, it can still be difficult to implement within small or medium-sized companies, where there is often little willingness to introduce processes perceived as adding “bureaucracy” to decision-making mechanisms.

For this reason, the three modules proposed in this project are designed to simplify and minimize the initial architectural effort, enabling the establishment of foundational elements upon which a more comprehensive process can later be built. This allows the framework to evolve alongside the organization, while also promoting the use of a common language and the creation of fundamental documents necessary to fulfill its mission.

<br/>

```
References:

1. Jager, E. (2023). Getting Started with Enterprise Architecture: A Practical and Pragmatic Approach to Learning the Basics of Enterprise Architecture. Apress
2. The Open Group. (2022). The TOGAF® Standard, 10th Edition. Open Group.

```


## 3. MODULE STRUCTURE: WHICH DOCUMENTS MUST BE COMPLETED?

As previously mentioned, the framework promotes the use of three main documents: Core Deliverables, Operational Deliverables, and Decision Deliverables. Although they can, in some cases, be completed without following a strict order, the process naturally encourages respecting their sequential order: 

1. **Core Deliverables**: A strategic-type document aimed at defining what the organization does (or should do) in order to operate. This is the first architectural deliverable and formalizes:
   - The organizational map
   - The map of roles and responsibilities
   - The organization’s capability catalog
   - An assessment of how prepared the organization is to adopt Artificial Intelligence within its operations.

2. **Operational Deliverables**: A practical-type document aimed at structuring how the organization should operate. This is the second deliverable in the process and includes:
   - Stakeholder map
   - Catalog of applications used by the organization
   - Catalog of technological infrastructure used by the organization
   - Process inventory and its relationship with organizational capabilities

3. **Decision Deliverables**: A critical-type document aimed at describing why the organization operates the way it does. This is the third and final deliverable, formalizing:
   - Basic organizational principles
   - Objectives and initiatives
   - Architectural decision records
   - Cost model
   - Roadmap

Additionally, each document includes an initial internal tab (0#), specifically intended to describe the purpose of each element and the considerations required to complete it correctly. 
It is strongly recommended to **avoid modifying table structures**, as they are tightly coupled to macro behavior through named ranges (Formulas → Name manager). The number of available records is intentionally limited to constrain data entry within the context of small and medium-sized organizations. Furthermore, the predefined maximum number of records for each element is directly related to the nature of the information being requested. For example, the number of core organizational principles to be entered in the Decision Deliverables document should not exceed five, as this aligns with the fundamental intent of such principles. 


## 4. CONSIDERATIONS

 - The documents include example data, generically structured to illustrate the full process. When populating them, it is recommended to remove any information that does not reflect the organization’s actual context.
 - Each element within the documents has an assigned purpose and a recommended audience. If the suggested roles do not align with the organization’s context, audiences should be adjusted to equivalent roles that do exist within the company.
 - A color-coding scheme is used to indicate which documents or sections must be completed:  
   - ![#1589F0](https://placehold.co/15x15/1589F0/1589F0.png) **Blue**: To be completed following any instructions provided in the initial tab (0#)
   - ![#b45f06](https://placehold.co/15x15/b45f06/b45f06.png) **Orange**: Not to be completed. Information will be generated automatically
   - ![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) **Green**: To be completed using information exported from another document.
- As mentioned, the documents contain embedded macros. For security reasons, these may be disabled by default and must be explicitly enabled
  <img width="999" height="472" alt="image" src="https://github.com/user-attachments/assets/1f02bfcf-cfda-407a-8840-e65a9d768f10" />
- Data connection content created through Power Query within each document must also be enabled.
  <img width="531" height="44" alt="Screenshot 2026-01-09 145058" src="https://github.com/user-attachments/assets/d467921b-647f-49b0-a7cd-432445b0aa59" />



