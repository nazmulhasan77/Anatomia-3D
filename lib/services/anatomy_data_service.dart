import '../models/organ_model.dart';
import '../models/body_system_model.dart';
import '../models/quiz_model.dart';
import '../models/disease_model.dart';
import '../models/user_profile_model.dart';

class AnatomyDataService {
  static final List<OrganModel> organs = [
    const OrganModel(
      id: 'heart',
      name: 'Heart',
      category: 'Cardiovascular System',
      description:
          'The heart is a muscular organ that pumps blood throughout the body. It is located in the chest cavity, between the lungs, slightly to the left behind the sternum.',
      location: 'Chest cavity, between lungs (Mediastinum)',
      function: 'Pumps blood throughout the body, maintains systemic and pulmonary circulation.',
      structure: [
        'Right Atrium: Receives deoxygenated blood from the body',
        'Right Ventricle: Pumps deoxygenated blood to the lungs',
        'Left Atrium: Receives oxygen-rich blood from lungs',
        'Left Ventricle: Pumps oxygenated blood to the entire body',
        'Mitral & Tricuspid atrioventricular valves',
        'Aorta & Pulmonary artery conduits',
      ],
      diseases: [
        'Coronary Artery Disease',
        'Myocardial Infarction (Heart Attack)',
        'Arrhythmia & Fibrillation',
        'Heart Failure',
      ],
      animation: 'Cardiac Cycle & Blood Flow',
      imageUrl: 'assets/organs/heart.png',
      systemId: 'cardiovascular',
      bodyX: 0.52,
      bodyY: 0.28,
      depthZ: 0.6,
      latinName: 'Cor',
      funFact: 'Your heart beats around 100,000 times a day and pumps about 2,000 gallons of blood!',
    ),
    const OrganModel(
      id: 'lungs',
      name: 'Lungs',
      category: 'Respiratory System',
      description:
          'The lungs are a pair of spongy, air-filled organs located on either side of the chest (thorax). Their primary role is oxygenating blood and expelling carbon dioxide.',
      location: 'Thoracic cavity, flanking the mediastinum and heart',
      function: 'Facilitates gas exchange: absorbs oxygen into red blood cells and expels carbon dioxide.',
      structure: [
        'Right Lung (3 lobes: superior, middle, inferior)',
        'Left Lung (2 lobes: superior, inferior, with cardiac notch)',
        'Bronchial Tree & Bronchioles',
        'Alveoli: Microscopic air sacs where capillary gas exchange happens',
        'Pleural membrane and Pleural fluid',
      ],
      diseases: [
        'Pneumonia',
        'Asthma',
        'Chronic Obstructive Pulmonary Disease (COPD)',
        'Bronchitis',
        'Pulmonary Fibrosis',
      ],
      animation: 'Breathing & Oxygen Exchange',
      imageUrl: 'assets/organs/lungs.png',
      systemId: 'respiratory',
      bodyX: 0.50,
      bodyY: 0.27,
      depthZ: 0.5,
      latinName: 'Pulmones',
      funFact: 'If you could spread out the surface area of both lungs, it would cover an entire tennis court (~70 sqm)!',
    ),
    const OrganModel(
      id: 'brain',
      name: 'Brain',
      category: 'Nervous System',
      description:
          'The brain is the command center of the human nervous system. It receives input from sensory organs and sends output signals to muscles throughout the body.',
      location: 'Cranial cavity inside the protective skull',
      function: 'Controls thought, memory, emotion, touch, motor skills, vision, breathing, temperature, and hunger.',
      structure: [
        'Cerebrum: Divided into frontal, parietal, occipital, and temporal lobes',
        'Cerebellum: Regulates motor control, balance, and coordination',
        'Brainstem: Pons, Medulla Oblongata, controlling autonomic life functions',
        'Limbic System: Hippocampus and Amygdala (emotions & memories)',
      ],
      diseases: [
        'Ischemic & Hemorrhagic Stroke',
        'Alzheimer\'s Disease',
        'Parkinson\'s Disease',
        'Epilepsy',
      ],
      animation: 'Neuron Synaptic Transmission',
      imageUrl: 'assets/organs/brain.png',
      systemId: 'nervous',
      bodyX: 0.50,
      bodyY: 0.08,
      depthZ: 0.4,
      latinName: 'Encephalon / Cerebrum',
      funFact: 'The human brain generates about 23 watts of electrical power—enough to illuminate a small LED bulb!',
    ),
    const OrganModel(
      id: 'kidney',
      name: 'Kidney',
      category: 'Urinary System',
      description:
          'The kidneys are two bean-shaped organs, each about the size of a fist. They filter wastes, extra water, and toxins from blood to form urine.',
      location: 'Retroperitoneal space in the posterior abdominal wall, below the ribcage',
      function: 'Removes waste products, balances body fluid volume, produces erythropoietin, and regulates blood pressure.',
      structure: [
        'Renal Cortex: Outer protective metabolic region',
        'Renal Medulla: Inner triangular pyramids',
        'Nephrons: ~1 million functional microscopic filtration units per kidney',
        'Renal Pelvis & Ureter conduit to bladder',
      ],
      diseases: [
        'Chronic Kidney Disease (CKD)',
        'Nephrolithiasis (Kidney Stones)',
        'Glomerulonephritis',
        'Polycystic Kidney Disease',
      ],
      animation: 'Renal Nephron Filtration',
      imageUrl: 'assets/organs/kidney.png',
      systemId: 'urinary',
      bodyX: 0.45,
      bodyY: 0.42,
      depthZ: 0.7,
      latinName: 'Ren',
      funFact: 'Kidneys filter around 180 liters of blood daily, but only ~1.5 to 2 liters are excreted as urine!',
    ),
    const OrganModel(
      id: 'liver',
      name: 'Liver',
      category: 'Digestive System',
      description:
          'The liver is the body\'s largest internal organ and chemical processing plant, responsible for over 500 vital metabolic functions.',
      location: 'Right upper quadrant of the abdominal cavity beneath the diaphragm',
      function: 'Detoxifies chemicals, produces bile for fat digestion, metabolizes drugs, and synthesizes blood-clotting proteins.',
      structure: [
        'Right and Left Lobes separated by the falciform ligament',
        'Hepatic Portal Vein and Hepatic Artery',
        'Hepatocytes: Metabolic parenchymal cells',
        'Bile Canaliculi and Gallbladder drainage duct',
      ],
      diseases: [
        'Non-Alcoholic Fatty Liver Disease',
        'Liver Cirrhosis',
        'Hepatitis A, B, C',
        'Liver Cancer (Hepatocellular Carcinoma)',
      ],
      animation: 'Bile Production & Toxin Neutralization',
      imageUrl: 'assets/organs/liver.png',
      systemId: 'digestive',
      bodyX: 0.55,
      bodyY: 0.38,
      depthZ: 0.5,
      latinName: 'Hepar',
      funFact: 'The liver is the only human internal organ that can regenerate itself completely from as little as 25% remaining tissue!',
    ),
    const OrganModel(
      id: 'stomach',
      name: 'Stomach',
      category: 'Digestive System',
      description:
          'A J-shaped muscular organ located on the left side of the upper abdomen that breaks down food into chyme using hydrochloric acid and enzymes.',
      location: 'Upper left quadrant of the abdomen, below diaphragm',
      function: 'Stores food, breaks it down with gastric juices, and churns it into liquid chyme for intestine absorption.',
      structure: [
        'Cardia, Fundus, Body, and Pylorus',
        'Pyloric sphincter valve',
        'Rugae: Folded internal stomach linings',
        'Gastric pits with parietal and chief cells',
      ],
      diseases: [
        'Gastric Ulcer',
        'Gastritis',
        'Gastroesophageal Reflux Disease (GERD)',
        'Gastroparesis',
      ],
      animation: 'Gastric Churning & Digestion',
      imageUrl: 'assets/organs/stomach.png',
      systemId: 'digestive',
      bodyX: 0.44,
      bodyY: 0.36,
      depthZ: 0.5,
      latinName: 'Gaster / Ventriculus',
      funFact: 'Stomach acid (pH 1.5–2.0) is strong enough to dissolve metal razor blades, but mucus protects your stomach lining!',
    ),
    const OrganModel(
      id: 'bones',
      name: 'Bones',
      category: 'Skeletal System',
      description:
          'The human skeletal framework comprises 206 bones in an adult, providing rigid support, shielding vulnerable organs, and housing bone marrow.',
      location: 'Distributed systematically throughout entire body framework',
      function: 'Structural support, vital organ protection, calcium/phosphorus reservoir, and hematopoiesis (blood cell creation).',
      structure: [
        'Axial Skeleton (Skull, vertebral column, ribs, sternum)',
        'Appendicular Skeleton (Limbs and shoulder/pelvic girdles)',
        'Compact cortical bone & Spongy trabecular bone',
        'Red and yellow bone marrow',
      ],
      diseases: [
        'Osteoporosis',
        'Osteoarthritis',
        'Bone Fractures',
        'Osteomalacia',
      ],
      animation: 'Joint Articulation & Bone Remodeling',
      imageUrl: 'assets/organs/bones.png',
      systemId: 'skeletal',
      bodyX: 0.50,
      bodyY: 0.55,
      depthZ: 0.3,
      latinName: 'Ossa',
      funFact: 'Human bone is ounce-for-ounce stronger than steel; a cubic inch of bone can bear a load of 19,000 lbs!',
    ),
    const OrganModel(
      id: 'muscles',
      name: 'Muscles',
      category: 'Muscular System',
      description:
          'Over 600 skeletal, smooth, and cardiac muscles that generate mechanical force through specialized sliding actin-myosin filaments.',
      location: 'Spans the entire body surface and internal hollow organs',
      function: 'Powers movement, maintains posture, stabilizes joints, and produces body heat via shivering and thermogenesis.',
      structure: [
        'Skeletal Muscles (voluntary striations)',
        'Cardiac Muscle (involuntary heart wall)',
        'Smooth Muscles (involuntary gut, vessels)',
        'Myofibrils, Sarcomeres, and Tendon connections',
      ],
      diseases: [
        'Muscular Dystrophy',
        'Myasthenia Gravis',
        'Muscle Strain & Tears',
        'Fibromyalgia',
      ],
      animation: 'Sarcomere Contraction Mechanism',
      imageUrl: 'assets/organs/muscles.png',
      systemId: 'muscular',
      bodyX: 0.50,
      bodyY: 0.65,
      depthZ: 0.2,
      latinName: 'Musculi',
      funFact: 'The strongest muscle in the human body based on weight is the masseter (jaw muscle)!',
    ),
    const OrganModel(
      id: 'eyes',
      name: 'Eyes',
      category: 'Sensory System',
      description:
          'Complex sensory organs that gather light stimuli, focus them through lenses, and convert photons into nerve impulses for visual comprehension.',
      location: 'Orbital cavities in the front facial skull',
      function: 'Converts visible light rays into electrochemical neuro-signals conveyed via optic nerves to the occipital cortex.',
      structure: [
        'Cornea & Iris / Pupil aperture',
        'Crystalline Lens for accommodation',
        'Retina: Rods (light) and Cones (color)',
        'Optic Nerve transmitting to brain',
      ],
      diseases: [
        'Cataracts',
        'Glaucoma',
        'Macular Degeneration',
        'Myopia & Hyperopia',
      ],
      animation: 'Light Refraction & Neural Processing',
      imageUrl: 'assets/organs/eyes.png',
      systemId: 'nervous',
      bodyX: 0.50,
      bodyY: 0.06,
      depthZ: 0.1,
      latinName: 'Oculi',
      funFact: 'Your eye muscles move more than 100,000 times a day—equivalent to walking 50 miles for leg muscles!',
    ),
  ];

  static final List<BodySystemModel> bodySystems = [
    const BodySystemModel(
      id: 'nervous',
      name: 'Nervous System',
      description:
          'The master control network consisting of brain, spinal cord, and peripheral nerves directing bodily reactions.',
      organs: ['brain', 'eyes'],
      icon: 'brain',
      primaryColorHex: 0xFFFFD600,
    ),
    const BodySystemModel(
      id: 'cardiovascular',
      name: 'Cardiovascular System',
      description:
          'Heart and expansive blood vessel grid delivering oxygenated blood, nutrients, and hormones to all tissues.',
      organs: ['heart'],
      icon: 'heart',
      primaryColorHex: 0xFFFF3366,
    ),
    const BodySystemModel(
      id: 'respiratory',
      name: 'Respiratory System',
      description:
          'Lungs, trachea, and alveoli exchanging oxygen from atmospheric air with carbon dioxide wastes.',
      organs: ['lungs'],
      icon: 'lungs',
      primaryColorHex: 0xFF00E5FF,
    ),
    const BodySystemModel(
      id: 'digestive',
      name: 'Digestive System',
      description:
          'Stomach, intestines, liver, and pancreas breaking down nutritional inputs for cellular metabolism.',
      organs: ['stomach', 'liver'],
      icon: 'stomach',
      primaryColorHex: 0xFFFF9100,
    ),
    const BodySystemModel(
      id: 'skeletal',
      name: 'Skeletal System',
      description:
          'Rigid framework of 206 articulated bones, cartilage, and ligaments shielding vital organs.',
      organs: ['bones'],
      icon: 'bone',
      primaryColorHex: 0xFFE0E0E0,
    ),
    const BodySystemModel(
      id: 'muscular',
      name: 'Muscular System',
      description:
          'Skeletal and smooth muscle tissues enabling locomotion, arterial constriction, and bodily posture.',
      organs: ['muscles'],
      icon: 'muscle',
      primaryColorHex: 0xFFFF5252,
    ),
    const BodySystemModel(
      id: 'urinary',
      name: 'Urinary System',
      description:
          'Kidneys, ureters, and bladder filtering metabolic wastes, toxins, and maintaining electrolyte balance.',
      organs: ['kidney'],
      icon: 'kidney',
      primaryColorHex: 0xFF7C4DFF,
    ),
  ];

  static final List<DiseaseModel> diseaseComparisons = [
    const DiseaseModel(
      id: 'lung_pneumonia',
      organId: 'lungs',
      organName: 'Lungs',
      diseaseName: 'Pneumonia',
      subtitle: 'Healthy Lung vs Pneumonia Lung',
      overview:
          'Pneumonia is an inflammatory condition of the lung primarily affecting the microscopic air sacs (alveoli). It is typically caused by viral or bacterial infection, causing air sacs to fill with fluid and pus.',
      comparisons: [
        DiseaseComparisonItem(
          metric: 'Color',
          healthyValue: 'Uniform pink, healthy tissue',
          diseasedValue: 'Dark/red mottled spots, congested',
        ),
        DiseaseComparisonItem(
          metric: 'Texture',
          healthyValue: 'Smooth, elastic, spongy',
          diseasedValue: 'Rough, dense, hepatized tissue',
        ),
        DiseaseComparisonItem(
          metric: 'Air sacs (Alveoli)',
          healthyValue: 'Clear, air-filled, expandable',
          diseasedValue: 'Inflamed, filled with exudate/fluid',
        ),
        DiseaseComparisonItem(
          metric: 'Gas Exchange Function',
          healthyValue: '100% optimal oxygen diffusion',
          diseasedValue: 'Severely impaired, reduced O2 saturation',
        ),
        DiseaseComparisonItem(
          metric: 'Breathing Effort',
          healthyValue: 'Effortless, silent, rhythmic',
          diseasedValue: 'Dyspnea, tachypnea, painful coughing',
        ),
      ],
      symptoms: [
        'Persistent cough with phlegm/pus',
        'High fever, chills, and shaking',
        'Shortness of breath during basic tasks',
        'Sharp chest pain when breathing deeply or coughing',
        'Fatigue, confusion (in elderly patients)',
      ],
      causes: [
        'Streptococcus pneumoniae bacteria',
        'Respiratory viruses (Influenza, RSV, SARS-CoV-2)',
        'Fungal spores (in immunocompromised individuals)',
        'Aspiration of food, liquid, or vomit into lungs',
      ],
      prevention: [
        'Pneumococcal & seasonal influenza vaccines',
        'Frequent hand hygiene and sanitization',
        'Cessation of tobacco smoking',
        'Strong immune health and adequate rest',
      ],
    ),
    const DiseaseModel(
      id: 'heart_infarction',
      organId: 'heart',
      organName: 'Heart',
      diseaseName: 'Myocardial Infarction',
      subtitle: 'Healthy Heart vs Heart Attack',
      overview:
          'A myocardial infarction (heart attack) occurs when blood flow decreases or stops to a part of the heart muscle, causing cellular necrosis due to lack of oxygen.',
      comparisons: [
        DiseaseComparisonItem(
          metric: 'Arterial Blood Supply',
          healthyValue: 'Unobstructed coronary arteries',
          diseasedValue: 'Atherosclerotic plaque rupture & thrombus occlusion',
        ),
        DiseaseComparisonItem(
          metric: 'Myocardial Tissue',
          healthyValue: 'Rich vascularization, pink contractile muscle',
          diseasedValue: 'Ischemic darkened necrotic tissue patch',
        ),
        DiseaseComparisonItem(
          metric: 'Rhythm / Electrical',
          healthyValue: 'Synchronous sinus rhythm (60-100 bpm)',
          diseasedValue: 'Ventricular fibrillation or severe arrhythmia',
        ),
        DiseaseComparisonItem(
          metric: 'Ejection Fraction',
          healthyValue: '55% - 70% stroke volume',
          diseasedValue: 'Critically reduced (<40%)',
        ),
      ],
      symptoms: [
        'Crushing retrosternal chest pain radiating to left arm or jaw',
        'Cold sweat (diaphoresis)',
        'Lightheadedness, dizziness, or syncope',
        'Sudden shortness of breath',
      ],
      causes: [
        'Coronary artery disease & ruptured atherosclerotic plaque',
        'Hypertension, elevated LDL cholesterol',
        'Smoking, obesity, sedentary lifestyle',
      ],
      prevention: [
        'Mediterranean or heart-healthy dietary habits',
        '150 minutes of weekly moderate aerobic exercise',
        'Blood pressure and cholesterol management',
        'Avoiding tobacco products',
      ],
    ),
  ];

  static final List<QuizModel> quizzes = [
    const QuizModel(
      id: 'q1',
      question: 'Which organ pumps blood throughout the entire human body?',
      options: ['Kidney', 'Heart', 'Liver', 'Lung'],
      correctOptionIndex: 1,
      explanation:
          'The heart is a muscular pump that continuously contracts to propel deoxygenated blood to the lungs and oxygenated blood to the systemic circulation.',
      organId: 'heart',
      difficulty: 'Easy',
    ),
    const QuizModel(
      id: 'q2',
      question: 'In which microscopic structures of the lungs does actual gas exchange occur?',
      options: ['Bronchi', 'Trachea', 'Alveoli', 'Larynx'],
      correctOptionIndex: 2,
      explanation:
          'Alveoli are tiny, balloon-like capillary-wrapped air sacs where oxygen diffuses into red blood cells and carbon dioxide diffuses into the exhaled breath.',
      organId: 'lungs',
      difficulty: 'Medium',
    ),
    const QuizModel(
      id: 'q3',
      question: 'Which organ is known as the body\'s chemical processing plant and can regenerate itself?',
      options: ['Pancreas', 'Liver', 'Spleen', 'Stomach'],
      correctOptionIndex: 1,
      explanation:
          'The liver performs over 500 vital functions including detoxification and bile secretion, and has the remarkable ability to regenerate from 25% of its mass.',
      organId: 'liver',
      difficulty: 'Medium',
    ),
    const QuizModel(
      id: 'q4',
      question: 'What is the primary functional filtration unit of the kidney called?',
      options: ['Nephron', 'Neuron', 'Alveolus', 'Hepatocyte'],
      correctOptionIndex: 0,
      explanation:
          'Each human kidney contains roughly 1 million nephrons, which filter blood plasma, reabsorb nutrients, and excrete nitrogenous wastes as urine.',
      organId: 'kidney',
      difficulty: 'Medium',
    ),
    const QuizModel(
      id: 'q5',
      question: 'Which part of the brain is primarily responsible for balance and motor coordination?',
      options: ['Cerebrum', 'Cerebellum', 'Brainstem', 'Hypothalamus'],
      correctOptionIndex: 1,
      explanation:
          'The cerebellum, situated beneath the occipital lobe, coordinates precision, timing, equilibrium, and smooth voluntary muscle movements.',
      organId: 'brain',
      difficulty: 'Medium',
    ),
    const QuizModel(
      id: 'q6',
      question: 'How many bones comprise the adult human skeletal system?',
      options: ['180', '206', '254', '300'],
      correctOptionIndex: 1,
      explanation:
          'While babies are born with roughly 270 soft cartilage bones, many fuse together during growth, resulting in 206 rigid bones in a mature adult.',
      organId: 'bones',
      difficulty: 'Easy',
    ),
    const QuizModel(
      id: 'q7',
      question: 'Which component of blood is responsible for carrying oxygen to cells?',
      options: ['Platelets', 'White blood cells', 'Red blood cells (Hemoglobin)', 'Plasma proteins'],
      correctOptionIndex: 2,
      explanation:
          'Erythrocytes (red blood cells) contain iron-rich hemoglobin molecules that bind oxygen molecules in the lungs and deliver them throughout tissues.',
      organId: 'heart',
      difficulty: 'Easy',
    ),
    const QuizModel(
      id: 'q8',
      question: 'Which gastric acid component gives the stomach its high acidity (pH 1.5–2.0)?',
      options: ['Hydrochloric acid (HCl)', 'Sulfuric acid', 'Acetic acid', 'Carbonic acid'],
      correctOptionIndex: 0,
      explanation:
          'Parietal cells in the gastric lining secrete hydrochloric acid (HCl), denaturing dietary proteins and sterilizing ingested microorganisms.',
      organId: 'stomach',
      difficulty: 'Hard',
    ),
    const QuizModel(
      id: 'q9',
      question: 'What type of photoreceptor in the human retina is responsible for color vision?',
      options: ['Rods', 'Cones', 'Corneal cells', 'Bipolar cells'],
      correctOptionIndex: 1,
      explanation:
          'Cone cells concentrated in the fovea detect red, green, and blue wavelengths for sharp, colorful daytime vision, while rods handle peripheral/night vision.',
      organId: 'eyes',
      difficulty: 'Medium',
    ),
    const QuizModel(
      id: 'q10',
      question: 'Which muscle in the human body exerts the highest bite force relative to its size?',
      options: ['Biceps brachii', 'Gluteus maximus', 'Masseter', 'Quadriceps'],
      correctOptionIndex: 2,
      explanation:
          'The masseter muscle located in the jaw can close teeth with a force exceeding 200 pounds (90 kg) on the molars!',
      organId: 'muscles',
      difficulty: 'Hard',
    ),
  ];

  static UserProfileModel defaultProfile = const UserProfileModel(
    name: 'Ahmed Rahman',
    title: 'Medical Explorer & Biology Student',
    email: 'ahmed.rahman@butterflydevs.com',
    chaptersCompleted: 12,
    quizPoints: 320,
    level: 5,
    badges: [
      BadgeModel(
        id: 'b1',
        title: 'Heart Pioneer',
        description: 'Completed comprehensive cardiovascular exploration',
        icon: 'favorite',
        isUnlocked: true,
        unlockedDate: 'Sep 10, 2026',
      ),
      BadgeModel(
        id: 'b2',
        title: 'Pulmonary Master',
        description: 'Mastered respiratory breathing mechanics & pathologies',
        icon: 'air',
        isUnlocked: true,
        unlockedDate: 'Sep 12, 2026',
      ),
      BadgeModel(
        id: 'b3',
        title: 'Neuro Genius',
        description: 'Scored 100% on nervous system synapse quiz',
        icon: 'psychology',
        isUnlocked: true,
        unlockedDate: 'Sep 13, 2026',
      ),
      BadgeModel(
        id: 'b4',
        title: 'Grand Anatomist',
        description: 'Unlocked all 6 anatomical layer systems',
        icon: 'military_tech',
        isUnlocked: false,
      ),
    ],
    bookmarkedOrganIds: ['heart', 'lungs', 'brain'],
  );

  static OrganModel? getOrganById(String id) {
    try {
      return organs.firstWhere((o) => o.id.toLowerCase() == id.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  static DiseaseModel? getDiseaseByOrganId(String organId) {
    try {
      return diseaseComparisons.firstWhere((d) => d.organId.toLowerCase() == organId.toLowerCase());
    } catch (_) {
      return diseaseComparisons.first; // default fallback
    }
  }

  static List<OrganModel> searchOrgans(String query) {
    if (query.trim().isEmpty) return organs;
    final q = query.toLowerCase().trim();
    return organs.where((o) {
      return o.name.toLowerCase().contains(q) ||
          o.category.toLowerCase().contains(q) ||
          o.description.toLowerCase().contains(q) ||
          o.function.toLowerCase().contains(q) ||
          o.diseases.any((d) => d.toLowerCase().contains(q));
    }).toList();
  }
}
