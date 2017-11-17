## Text and Network Analytics
####Q4E. Are there trends or similarities in the way charities describe themselves? Do these serve to predict the size of an organization or its likelihood to get funded?

What is a [charity](https://www.canada.ca/en/revenue-agency/services/charities-giving/charities/applying-registration/types-registered-charities-designations.html)?
There are three types of registered charities. Every registered charity is designated as a:
* charitable organization;
* public foundation, or
* private foundation.

Each Charity is categorized into 5 broad types and multiple sub-types [(link)](http://www.cra-arc.gc.ca/chrts-gvng/lstngs/rqstfrm-eng.html), which are:
* Benefits to the community and other categories (Community and Other)
* Education
* Health
* Religion - Churches and other places of worship (Religion)
* Welfare


How can we acquire charities description information (by year)? OwnCloud data or the [CRA website](https://www.canada.ca/en/revenue-agency/services/charities-giving/charities-listings.html).
* well what does it look like? let's look at the [Calgary Home Builders Foundation](http://www.cra-arc.gc.ca/ebci/haip/srch/t3010form22quickview-eng.action?r=http%3A%2F%2Fwww.cra-arc.gc.ca%3A80%2Febci%2Fhaip%2Fsrch%2Fbasicsearchresult-eng.action%3Fk%3Dcalgary%2Bfoundation%26amp%3Bs%3Dregistered%26amp%3Bp%3D1%26amp%3Bb%3Dtrue&fpe=2016-12-31&b=118823608RR0001&n=CALGARYHOMEBUILDERSFOUNDATION)
  * 2 views: Quick View and Full View
  * Can also put in a request for [charity data](http://www.cra-arc.gc.ca/chrts-gvng/lstngs/rqstfrm-eng.html)


What types of descriptive trends are we talking about?
* use the charitable organization, public foundation or private foundation "Programs and Activities Descriptions (ongoing and new programs)"
* **TASK (Byron C.)**: histogram of these types of charities over time ... e.g. is there a trend towards more public foundations? in calgary, alberta, other provinces, and/or canada?
* text analytics: **TASK (David A.)** dtm (term frequencies / key words, word cloud), **TASK (Tatiana M.)** topic modelling (LDA)to compare calgary, alberta, other provinces, and/or canada descriptions
  * trends suggestion: plot the top X topics / frequencies for each geographic region by year and see how they are changing over time


Does the size of the organization predict the likelihood of funding via a grant by the Calgary Foundation?
* How to measure size of the organization?
  * one way is Budget. Last 5 years budget information is available on CRA website in Quick View by year, for example:

**Revenue**
* Receipted donations $19,362 (9%)
* Non-receipted donations $201,428 (90%)
* Gifts from other charities (0%)
* Government funding (0%)
* All other revenue $1,818 (1%)
* Total revenue: $222,608

**Expenses**
* Charitable program $305,000 (38%)
* Management and administration (0%)
* Fundraising $101,128 (12%)
* Political activities (0%)
* Gifts to other registered charities and qualified donees $406,128 (50%)
* Other $0 (0%)
* Total expenses: $812,256

* this information is also available on OwnCloud via the Financial Statements D and Schedule 6. Detailed information about each line of the financial statement can be found [here](https://www.canada.ca/en/revenue-agency/news/cra-multimedia-library/charities-video-gallery/transcript-completing-form-t3010-13-registered-charity-information-return-segment-4-schedule-6-detailed-financial-information-schedule-7-political.html).
  * to get the equivalent information as the list above for Revenue you would use:
    * **Revenue**
    * Receipted donations Line 4500
    * Non-receipted donations Line 4530
    * Gifts from other charities Line 4510
    * Government funding - Line 4540 (federal); Line 4550 (provincial); Line 4560 (municipal)
    * All other revenue - Line 4575 (Non-tax receipted amounts outside of Canada); Line 4580 (Interest and dividends); Line 4590 (Gross proceeds from sale of assets); Line 4630 (Gross amount of non-tax receipted revenue from fundraising)
    * Total revenue Line 4700
    * **Expenses**
    * Charitable program Line 5000 (Charitable organizations primarily)
    * Management and administration Line 5010
    * Fundraising $101,128 Line 5020
    * Political activities Line 5030
    * Gifts to other registered charities and qualified donees Line 5050 (Public and Private foundations primarily)
    * Other expenditures Line 5040
    * Total expenses Line 5100



  * can compare size of charity (based on budget alone) and the types of projects funded by the Calgary Foundation
    * can use machine learning to categorize the charity based on the description of the charity into community sector categories:
        * arts and heritage,
        * education,
        * community development,
        * health and wellness,
        * environment and animal welfare,
        * human services and faith,
        * and religion.
      * train a model from the list of charities we have that are categorized (labeled) and predict community categories for remaining charities based on charity description and other features if available
    * can add in additional features to see which are the most important like number of employees, charity description, number of board of trustees members, which board or trustee member, which sector of the community that the grant is supporting
      * assume all other Calgary charities were not funded



####Q4A. How integrated are the board of trustees for CRA Charities within Calgary? Across Alberta? Across Canada?

* Where does the Board of Trustees data exist? OwnCloud? CRA website?
  * CRA website for charity -> Full View -> Section B: Directors/trustees and like officials -> [Form T1235,Directors/Trustees and Like Officials Worksheet](http://www.cra-arc.gc.ca/ebci/haip/srch/t3010form23officers-eng.action?b=118823608RR0001&fpe=2016-12-31&n=CALGARY+HOME+BUILDERS+FOUNDATION&r=http%3A%2F%2Fwww.cra-arc.gc.ca%3A80%2Febci%2Fhaip%2Fsrch%2Ft3010form23-eng.action%3Fb%3D118823608RR0001%26amp%3Bfpe%3D2016-12-31%26amp%3Bn%3DCALGARY%2BHOME%2BBUILDERS%2BFOUNDATION%26amp%3Br%3Dhttp%253A%252F%252Fwww.cra-arc.gc.ca%253A80%252Febci%252Fhaip%252Fsrch%252Fbasicsearchresult-eng.action%253Fk%253Dcalgary%252Bfoundation%2526amp%253Bs%253Dregistered%2526amp%253Bp%253D1%2526amp%253Bb%253Dtrue)

* what's the gender ratio of charities?: calgary, alberta, other provinces, canada
  * research article: Women on corporate boards of directors and their influence on corporate philanthropy https://link.springer.com/article/10.1023%2FA%3A1021626024014?LI=true

* are the charities funded by Calgary Foundation at arm's length?
Charitable organization definition:
  * it is established as a corporation, a trust, or under a constitution;
  * it has only charitable purposes;
  * it primarily carries on its own charitable activities;
  * it has more than 50% of its directors, trustees, or like officials dealing with each other at arm's length; and
  * it generally receives its funding from a variety of arm's length donors.

[Arm's length:](https://www.canada.ca/en/revenue-agency/services/charities-giving/charities/charities-giving-glossary.html#arms)
The term "at arm's length" describes a relationship where persons act independently of each other or who are not related. The term "not at arm's length" means persons acting in concert without separate interests or who are related.
Related persons are individuals who are related to each other by blood, marriage or common law partnership, or adoption. Examples of blood relatives include grandparents, parents, brothers, sisters, children, and grandchildren. Examples of persons related by spousal relationship include the grandparents of a spouse, the parents of a spouse, the brothers and sisters of a spouse, the children of a spouse, the spouse of a brother or a sister, the spouse of a child, and the spouse of a grandchild. Generally, in determining arm's length relationships, common law partners are treated in the same way as legally married spouses. Adopted children are treated in the same way as blood-related children.
Related persons also include individuals or groups and the corporations in which they have a controlling interest. Persons related to these individuals or groups are also considered related to those corporations.


####Notes
* other ways to slice the pie
Grants by Areas of Need (4% Strengthening Relations with Indigenous Populations, 7% Pursuing a Sustainable Future, 8% Encouraging Mental Health,9% Living a Creative Life, 15% Reducing Poverty, 57% Community (arts & heritage, education, community development, health &wellness, environment & animal welfare, human services   and faith & religion)
  * Grants by Type (Scholarships, Capacity Building, Capital, Program Support, General Charitable Support)
  * Grants by Fund Type (Charitable Organization, Community, Field of Interest, Donor Designated, Donor Advised)
  * Grants by Geography (International, Canada, Alberta, Calgary & Area)
  * Grants by Dollar Amount (Greater than $100,000, $10,001 to $100,000, 0 to $10,000)

* How does funding compare with the identified [vital priorities](http://calgary-foundation.s3.amazonaws.com/mercury_assets/2005/original.pdf?1506623433)
Vital Priorities
In 2015, the Foundation, along with community partners and stakeholders, identified five Vital Priorities on
which to place additional leadership and support for the next ten years. These Vital Priorities are:
 * Living Standards: Reducing Poverty
 * Arts: Living a Creative Life
 * Wellness: Encouraging Mental Health
 * Environment: Pursuing a Sustainable Future
 * Community Connections: Strengthening Relations with Indigenous Populations

This year, the Foundation provided 593 grants worth $17.6 million to specific initiatives that support
the five Vital Priority areas. “Poverty Reduction” attracted the most financial support followed by “Living
a Creative Life”. Both of these priorities benefit from the existence of established, well-known strategies
that collaboratively address these issues. Additional financial support for the other three Vital Priorities will increase as the Foundation supports the emergence of similar, collaborative strategies.

* research articles
Predicting the effectiveness of grant-making  http://onlinelibrary.wiley.com/doi/10.1002/jsc.747/full
When Government Becomes the Principal Philanthropist: The Effects of Public Funding on Patterns of Nonprofit Governance http://onlinelibrary.wiley.com/doi/10.1111/j.1540-6210.2007.00729.x/full
