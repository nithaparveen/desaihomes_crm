class DummyStatusList {
  static final List<Map<String, String>> statuses = [
    {
      'name': 'New Leads',
      'bgColor': '#ECEEFF',
      'textColor': '#4D4AEA',
      'slug': 'new-leads'
    },
    {
      'name': 'Booked',
      'bgColor': '#ECFFED',
      'textColor': '#3FC600',
      'slug': 'booked'
    },
    {
      'name': 'Lost',
      'bgColor': '#FFF8EC',
      'textColor': '#EE6056',
      'slug': 'lost'
    },
    {
      'name': 'In Followup',
      'bgColor': '#ECEEFF',
      'textColor': '#941492',
      'slug': 'in-followup'
    },
    {
      'name': 'Casual Enquiry',
      'bgColor': '#ECFFEF',
      'textColor': '#3D9414',
      'slug': 'casual-enquiry'
    },
    {
      'name': 'No Responce',
      'bgColor': '#FFF6D8',
      'textColor': '#C8A015',
      'slug': 'no-responce'
    },
    {
      'name': 'Repeated Lead',
      'bgColor': '#FFF0DC',
      'textColor': '#FEA834',
      'slug': 'repeated-lead'
    },
    {
      'name': 'Wrong Lead',
      'bgColor': '#FFE7E7',
      'textColor': '#FF0000',
      'slug': 'wrong-lead'
    },
    {
      'name': 'Fake Lead',
      'bgColor': '#FFE7E7',
      'textColor': '#FF0000',
      'slug': 'fake-lead'
    },
    {
      'name': 'Wrong Location',
      'bgColor': '#FFE7E7',
      'textColor': '#FF0000',
      'slug': 'wrong-location'
    },
    {
      'name': 'Unable to Convert',
      'bgColor': '#FFF3E0',
      'textColor': '#F57C00',
      'slug': 'unable-to-convert'
    },
    {
      'name': 'Dropped',
      'bgColor': '#E7F4FF',
      'textColor': '#2F86CF',
      'slug': 'dropped'
    },
  ];

  // Helper method to find status details
  static Map<String, String> getStatusDetails(String statusName) {
    return statuses.firstWhere(
      (status) => status['name'] == statusName,
      orElse: () => {
        'bgColor': '#F5F5F5', 
        'textColor': '#000000'
      },
    );
  }
}