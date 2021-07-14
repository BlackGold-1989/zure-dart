const jsonData1 = [
  {
    'id' : '1',
    'title' : 'General Physic',
    'color' : '#e81f00',
    'sub' : [
      {
        'id' : '10',
        'title' : 'Electrical quantities',
        'color' : '#339f02',
        'sub' : [],
      },
      {
        'id' : '11',
        'title' : 'Energy, work and power',
        'color' : '#339f02',
        'sub' : [],
      },
      {
        'id' : '12',
        'title' : 'Energy, work and power (LINK)',
        'color' : '#339f02',
        'sub' : [],
      },
      {
        'id' : '13',
        'title' : 'Force',
        'color' : '#339f02',
        'sub' : [],
      },
      {
        'id' : '14',
        'title' : 'Force (LINK)',
        'color' : '#339f02',
        'sub' : [],
      },
      {
        'id' : '15',
        'title' : 'Length volume and time',
        'color' : '#339f02',
        'sub' : [],
      },
      {
        'id' : '16',
        'title' : 'Mass, weight and density',
        'color' : '#339f02',
        'sub' : [],
      },
      {
        'id' : '17',
        'title' : 'Momentum',
        'color' : '#339f02',
        'sub' : [],
      },
      {
        'id' : '18',
        'title' : 'Motion',
        'color' : '#339f02',
        'sub' : [],
      },
      {
        'id' : '19',
        'title' : 'Pressure',
        'color' : '#339f02',
        'sub' : [],
      },
    ],
  },
  {
    'id' : '2',
    'title' : 'Thermal Physic',
    'color' : '#f27592',
    'sub' : [],
  },
  {
    'id' : '3',
    'title' : 'Properties of waves',
    'color' : '#f0580d',
    'sub' : [
      {
        'id' : '30',
        'title' : 'Electromagnet spectrum',
        'color' : '#339f02',
        'sub' : [],
      },
      {
        'id' : '31',
        'title' : 'General wav properties',
        'color' : '#339f02',
        'sub' : [],
      },
      {
        'id' : '33',
        'title' : 'Lights',
        'color' : '#339f02',
        'sub' : [],
      },
      {
        'id' : '34',
        'title' : 'Sound',
        'color' : '#339f02',
        'sub' : [],
      },
    ],
  },
  {
    'id' : '4',
    'title' : 'Electricity and magnetism',
    'color' : '#f0b302',
    'sub' : [],
  },
  {
    'id' : '5',
    'title' : 'Atomic Physic',
    'color' : '#8278d0',
    'sub' : [
      {
        'id' : '50',
        'title' : 'Radioactivity',
        'color' : '#339f02',
        'sub' : [
          {
            'id' : '500',
            'title' : 'Concepts',
            'color' : '#4196c4',
            'sub' : [],
          },
          {
            'id' : '501',
            'title' : 'Radioactivity detection',
            'color' : '#4196c4',
            'sub' : [],
          },
          {
            'id' : '502',
            'title' : 'Safety precautions',
            'color' : '#4196c4',
            'sub' : [],
          },
          {
            'id' : '503',
            'title' : 'Safety precautions (LINK)',
            'color' : '#4196c4',
            'sub' : [],
          },
        ],
      },
      {
        'id' : '51',
        'title' : 'The nuclear atom',
        'color' : '#339f02',
        'sub' : [
          {
            'id' : '510',
            'title' : 'Atomic model',
            'color' : '#4196c4',
            'sub' : [],
          },
          {
            'id' : '511',
            'title' : 'Atomic nucleus',
            'color' : '#4196c4',
            'sub' : [],
          },
        ],
      },
      {
        'id' : '52',
        'title' : 'The nuclear atom (LINK)',
        'color' : '#339f02',
        'sub' : [
          {
            'id' : '520',
            'title' : 'Atomic model',
            'color' : '#4196c4',
            'sub' : [],
          },
        ],
      },
    ],
  },
];

const circleRadius = 200.0;
const itemDelta = 50.0;
const itemWidth = 80.0;
const itemHeight = 50.0;

const stroke = 2.0;
const lineDotWidth = 3.0; //percent value
const lineDotSpace = 2.0; //percent value

const duringAnimation = 300;
const animationStep = 15;