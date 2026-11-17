import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/live_lecture_model.dart';
import '../models/mcq_model.dart';
import '../models/ppt_model.dart';

class MockDatabase {
  static List<CourseModel> getInitialCourses() {
    return [
      CourseModel(
        id: 'course_1',
        title: 'IBPS-AFO (Agriculture Field Officer) Target Batch 2026-27',
        subtitle: 'Comprehensive Pre + Mains Preparation for Scale-I Specialist Officer',
        description: 'Complete syllabus coverage for IBPS AFO Prelims & Mains. Includes live interactive lectures, downloadable chapter PPT notes, weekly speed MCQ drills, and previous 10 years solved papers.',
        instructorId: 'educator_ach',
        instructorName: 'Agriculture Coaching Hisar Team',
        instructorTitle: 'Senior Agriculture Faculty & Exam Specialists',
        instructorAvatar: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=200&q=80',
        price: 2499.0,
        originalPrice: 6999.0,
        thumbnailUrl: 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?auto=format&fit=crop&w=800&q=80',
        category: 'IBPS AFO',
        rating: 4.95,
        reviewsCount: 748,
        isLiveNow: true,
        activeLiveLectureId: 'live_agri_1',
        features: [
          '80+ Hours of Live & Recorded Agriculture Lectures',
          'Complete Agronomy, Horticulture, Soil Science & Animal Husbandry',
          'Bi-Weekly MCQ Mock Tests with Detailed Explanations',
          'Full-Color Presentation PPTs & Downloadable Revision Notes',
          'Direct 100% Secure UPI Fee Payment via PhonePe, GPay, Paytm, BHIM',
          'Doubt Solving & Personal Mentorship on WhatsApp & Telegram',
        ],
        modules: [
          CourseModule(
            id: 'm_agri_1',
            title: 'Module 1: General Agriculture & Agronomy Fundamentals',
            description: 'Classification of crops, tillage, seed technology, cropping systems',
            order: 1,
            lessons: [
              const Lesson(
                id: 'l_agri_1',
                title: 'Introduction to IBPS AFO Exam Pattern & High-Weightage Topics',
                description: 'Complete blueprint of Prelims and Mains agriculture syllabus.',
                durationMinutes: 20,
                type: LessonType.video,
                contentUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                isFreePreview: true,
                isCompleted: true,
              ),
              const Lesson(
                id: 'l_agri_2',
                title: 'Tillage, Cropping Systems & Agricultural Meteorology',
                description: 'Weather parameters, monsoon dynamics, and primary/secondary tillage.',
                durationMinutes: 38,
                type: LessonType.video,
                contentUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
                isFreePreview: false,
                attachedPdfUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
              ),
              const Lesson(
                id: 'l_agri_3',
                title: 'Module 1 Assessment: Agronomy & Soil Science MCQ Test',
                description: 'Test your understanding of crop production principles.',
                durationMinutes: 15,
                type: LessonType.quiz,
                contentUrl: '',
                linkedQuizId: 'quiz_agri_1',
              ),
            ],
          ),
          CourseModule(
            id: 'm_agri_2',
            title: 'Module 2: Soil Science, Plant Nutrients & Irrigation',
            description: 'Soil physical properties, NPK dynamics, micronutrients, drip/sprinkler',
            order: 2,
            lessons: [
              const Lesson(
                id: 'l_agri_4',
                title: 'Soil Fertility, Essential Plant Nutrients & Fertilizer Calculation',
                description: 'Essential macro and micro nutrients, deficiency symptoms in crops.',
                durationMinutes: 45,
                type: LessonType.video,
                contentUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
                isFreePreview: false,
                linkedPptId: 'ppt_agri_1',
              ),
              const Lesson(
                id: 'l_agri_5',
                title: 'Irrigation Methods, Water Use Efficiency & Watershed Management',
                description: 'Modern micro-irrigation systems and water management.',
                durationMinutes: 40,
                type: LessonType.video,
                contentUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
                isFreePreview: false,
              ),
            ],
          ),
          CourseModule(
            id: 'm_agri_3',
            title: 'Module 3: Horticulture, Entomology & Plant Pathology',
            description: 'Fruit production, vegetable science, insect-pest & disease control',
            order: 3,
            lessons: [
              const Lesson(
                id: 'l_agri_6',
                title: 'Major Fruit & Vegetable Crops: Production Packages',
                description: 'Varieties, nursery techniques, and post-harvest management.',
                durationMinutes: 50,
                type: LessonType.video,
                contentUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
                isFreePreview: false,
              ),
            ],
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      CourseModel(
        id: 'course_2',
        title: 'ICAR-JRF & SRF Agronomy & Soil Science Foundation Batch',
        subtitle: 'For M.Sc. & Ph.D. Entrance in Top State & Central Agri Universities',
        description: 'Rigorous conceptual coaching for ICAR PG exams with in-depth statistical methods, genetics, plant physiology, weed science, and organic farming techniques.',
        instructorId: 'educator_ach',
        instructorName: 'Agriculture Coaching Hisar Team',
        instructorTitle: 'ICAR Rankers & Senior Faculty',
        instructorAvatar: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=200&q=80',
        price: 2999.0,
        originalPrice: 7999.0,
        thumbnailUrl: 'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=800&q=80',
        category: 'ICAR JRF',
        rating: 4.92,
        reviewsCount: 420,
        isLiveNow: false,
        features: [
          'Detailed Theory Classes on Plant Breeding, Agronomy & Soil Science',
          'ICAR JRF Exam Previous 15 Years Question Paper Analysis',
          'Topic-wise PPT Lecture Decks & Mind Maps',
          'Weekly Subject-Specific MCQ Tests',
        ],
        modules: [
          CourseModule(
            id: 'm_jrf_1',
            title: 'Module 1: Principles of Weed Science & Herbicides',
            description: 'Classification of weeds, herbicide modes of action, integrated weed management',
            order: 1,
            lessons: [
              const Lesson(
                id: 'l_jrf_1',
                title: 'Weed Ecology & Herbicide Selectivity Mechanisms',
                description: 'Key principles for ICAR JRF Agronomy paper.',
                durationMinutes: 32,
                type: LessonType.video,
                contentUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                isFreePreview: true,
              ),
            ],
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      CourseModel(
        id: 'course_3',
        title: 'Haryana ADO & HDO Complete Crash Course & Test Series',
        subtitle: 'Specialized for Haryana Agriculture & Horticulture Development Officer',
        description: 'Complete syllabus oriented coaching covering Haryana agricultural schemes, soil health cards, package of practices for Rabi & Kharif crops in Haryana, and daily mock tests.',
        instructorId: 'educator_ach',
        instructorName: 'Agriculture Coaching Hisar Team',
        instructorTitle: 'Specialist Exam Mentors',
        instructorAvatar: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=200&q=80',
        price: 1999.0,
        originalPrice: 4999.0,
        thumbnailUrl: 'https://images.unsplash.com/photo-1592982537447-7440770cbfc9?auto=format&fit=crop&w=800&q=80',
        category: 'Haryana ADO',
        rating: 4.88,
        reviewsCount: 310,
        isLiveNow: false,
        features: [
          'State Specific Agriculture Knowledge & CCS HAU Package of Practices',
          'Full-Length ADO Mock Exams with Detailed Key & Explanations',
          'Downloadable Presentation Slides and Summary PDFs',
        ],
        modules: [
          CourseModule(
            id: 'm_ado_1',
            title: 'Module 1: Crop Production Guidelines for Haryana',
            description: 'Wheat, Mustard, Cotton, Paddy & Pearl Millet packages',
            order: 1,
            lessons: [
              const Lesson(
                id: 'l_ado_1',
                title: 'High-Yielding Varieties & Agronomic Practices in Haryana',
                description: 'Focus on recent CCS HAU released varieties.',
                durationMinutes: 28,
                type: LessonType.video,
                contentUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                isFreePreview: true,
              ),
            ],
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  static List<LiveLectureModel> getInitialLiveLectures() {
    return [
      LiveLectureModel(
        id: 'live_agri_1',
        courseId: 'course_1',
        courseTitle: 'IBPS-AFO Target Batch 2026-27',
        title: '🔴 Live Class: Soil Science & Essential Nutrients with Live MCQ Solving',
        description: 'Join Agriculture Coaching Hisar faculty live for in-depth discussion on Nitrogen, Phosphorus, and Potassium deficiency symptoms, followed by live student doubt clearing.',
        instructorName: 'Agriculture Coaching Hisar',
        instructorAvatar: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=200&q=80',
        scheduledStartTime: DateTime.now().subtract(const Duration(minutes: 15)),
        durationMinutes: 90,
        isLiveNow: true,
        activeViewerCount: 142,
        linkedPptId: 'ppt_agri_1',
        chatMessages: [
          LiveChatMessage(
            id: 'cm1',
            senderId: 's1',
            senderName: 'Vikas Bishnoi',
            message: 'Ram Ram Sir! Audio and PPT slides are clearly visible.',
            isEducator: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
          ),
          LiveChatMessage(
            id: 'cm2',
            senderId: 'educator_ach',
            senderName: 'Agriculture Coaching Hisar',
            message: 'Welcome students! Today we are discussing High-Weightage Plant Nutrition MCQs for IBPS AFO. Keep your notebooks ready.',
            isEducator: true,
            timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          ),
          LiveChatMessage(
            id: 'cm3',
            senderId: 's2',
            senderName: 'Pooja Rani',
            message: 'Sir, please also explain the difference between hidden hunger and luxury consumption in Potassium.',
            isEducator: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
          ),
        ],
      ),
      LiveLectureModel(
        id: 'live_agri_2',
        courseId: 'course_1',
        courseTitle: 'IBPS-AFO Target Batch 2026-27',
        title: 'Upcoming: Agricultural Current Affairs & Recent Govt Schemes',
        description: 'Comprehensive coverage of PMFBY, e-NAM, PM-KISAN, and MSP updates for AFO.',
        instructorName: 'Agriculture Coaching Hisar',
        instructorAvatar: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=200&q=80',
        scheduledStartTime: DateTime.now().add(const Duration(hours: 4)),
        durationMinutes: 60,
        isLiveNow: false,
        activeViewerCount: 0,
      ),
    ];
  }

  static List<McqQuiz> getInitialQuizzes() {
    return [
      McqQuiz(
        id: 'quiz_agri_1',
        courseId: 'course_1',
        courseTitle: 'IBPS-AFO Target Batch 2026-27',
        title: 'Agronomy & Soil Science High-Yield MCQ Drill',
        description: 'Speed assessment test based on the latest IBPS AFO and ICAR JRF exam pattern.',
        durationMinutes: 10,
        passingPercentage: 60.0,
        createdBy: 'Agriculture Coaching Hisar',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        questions: [
          const McqQuestion(
            id: 'qa_1',
            questionText: 'Which nutrient is known as the "Traffic Policeman" in plants due to its role in stomatal regulation and enzyme activation?',
            options: [
              'Nitrogen (N)',
              'Phosphorus (P)',
              'Potassium (K)',
              'Zinc (Zn)',
            ],
            correctOptionIndex: 2,
            explanation: 'Potassium (K) regulates the opening and closing of stomata, water balance, and activates more than 60 plant enzymes, earning the title "Traffic Policeman of the Plant".',
            marks: 2,
          ),
          const McqQuestion(
            id: 'qa_2',
            questionText: 'What is the critical growth stage for irrigation in Wheat crop?',
            options: [
              'Crown Root Initiation (CRI) stage',
              'Tillering stage',
              'Milking stage',
              'Dough stage',
            ],
            correctOptionIndex: 0,
            explanation: 'Crown Root Initiation (CRI) stage occurs around 21 to 25 days after sowing and is the most critical irrigation stage in wheat. Delay causes significant yield reduction.',
            marks: 2,
          ),
          const McqQuestion(
            id: 'qa_3',
            questionText: '"Khaira" disease of Rice is caused by the deficiency of which mineral element?',
            options: [
              'Iron (Fe)',
              'Zinc (Zn)',
              'Manganese (Mn)',
              'Copper (Cu)',
            ],
            correctOptionIndex: 1,
            explanation: 'Khaira disease in rice is caused by Zinc deficiency, characterized by chlorosis and rusty brown spots on young leaves. It was first identified by Dr. Y.L. Nene at Pantnagar in 1966.',
            marks: 2,
          ),
          const McqQuestion(
            id: 'qa_4',
            questionText: 'Which form of nitrogen is primarily absorbed by the Paddy (Rice) crop in submerged conditions?',
            options: [
              'Nitrate form (NO3-)',
              'Ammoniacal form (NH4+)',
              'Nitrite form (NO2-)',
              'Elemental Nitrogen (N2)',
            ],
            correctOptionIndex: 1,
            explanation: 'Due to anaerobic/reducing conditions in submerged paddy soils, nitrogen is conserved and absorbed in the ammoniacal (NH4+) form.',
            marks: 2,
          ),
          const McqQuestion(
            id: 'qa_5',
            questionText: 'According to the official Merchant UPI payment details for Agriculture Coaching Hisar, what is the valid VPA?',
            options: [
              'ach@upi',
              '8053127034@sbi',
              'agricoaching@okhdfc',
              '8053127034@paytm',
            ],
            correctOptionIndex: 1,
            explanation: 'The official verified merchant UPI ID for Agriculture Coaching Hisar is 8053127034@sbi.',
            marks: 2,
          ),
        ],
      ),
    ];
  }

  static List<PptDeck> getInitialPptDecks() {
    return [
      PptDeck(
        id: 'ppt_agri_1',
        courseId: 'course_1',
        courseTitle: 'IBPS-AFO Target Batch 2026-27',
        title: 'Essential Plant Nutrients & Soil Fertility Masterdeck',
        topic: 'Soil Science & Plant Nutrition',
        description: 'Comprehensive presentation slides covering primary, secondary, and micronutrients, deficiency symptoms on plant parts, and fertilizer application.',
        instructorName: 'Agriculture Coaching Hisar',
        sharedAt: DateTime.now().subtract(const Duration(days: 2)),
        viewsCount: 284,
        slides: [
          const PptSlide(
            slideNumber: 1,
            title: 'Essential Plant Nutrients (Arnon & Stout Criteria)',
            subtitle: 'Agriculture Coaching Hisar • Foundation Lecture',
            bulletPoints: [
              '17 Essential plant nutrients required for higher plants',
              'Criteria of Essentiality formulated by Arnon & Stout (1939), refined in 1954',
              'Basic Structural Nutrients: Carbon (C), Hydrogen (H), Oxygen (O) [95% of plant biomass]',
              'Primary Macronutrients: Nitrogen (N), Phosphorus (P), Potassium (K)',
            ],
            notes: 'Welcome students of Agriculture Coaching Hisar. Today we analyze essential nutrient functions for upcoming IBPS AFO and ICAR exams.',
          ),
          const PptSlide(
            slideNumber: 2,
            title: 'Nutrient Mobility & Deficiency Symptom Locations',
            subtitle: 'Key Diagnostic Rules for Competitive Exams',
            bulletPoints: [
              'Highly Mobile Nutrients (N, P, K, Mg): Deficiency appears first on OLDER (lower) leaves',
              'Moderately Mobile (Zn): Deficiency appears on MIDDLE leaves',
              'Less Mobile (S, Fe, Mn, Cu): Deficiency appears on YOUNGER (upper) leaves',
              'Immobile Nutrients (Ca, B): Deficiency appears on TERMINAL BUDS / Growing tips',
            ],
            codeSnippet: '''// Quick Revision Rule for AFO:
// Old Leaves  -> N, P, K, Mg, Mo
// Young Leaves-> Fe, Mn, Cu, S
// Apical Bud  -> Ca, B''',
            notes: 'Questions from this single table appear repeatedly in IBPS AFO and state ADO exams every year.',
          ),
          const PptSlide(
            slideNumber: 3,
            title: 'Fertilizer Equivalent Calculations',
            subtitle: 'How to calculate commercial fertilizer quantity',
            bulletPoints: [
              'Urea contains 46% Nitrogen',
              'Single Super Phosphate (SSP) contains 16% P2O5 and 11-12% Sulphur',
              'Muriate of Potash (MOP / KCl) contains 60% K2O',
              'Diammonium Phosphate (DAP) contains 18% N and 46% P2O5',
            ],
            notes: 'Remember DAP supplies both Nitrogen and Phosphorus, so subtract the N contributed by DAP when calculating Urea requirements.',
          ),
          const PptSlide(
            slideNumber: 4,
            title: 'Instant Fee Payment & UPI Verification',
            subtitle: 'Direct Merchant Settlement Details',
            bulletPoints: [
              'Institute: Agriculture Coaching Hisar',
              'Official Merchant UPI VPA: 8053127034@sbi',
              'Supports: Google Pay, PhonePe, Paytm, BHIM, CRED & All UPI Apps',
              'Instant Course Unlock & Receipt generation upon fee transfer',
            ],
            notes: 'Students can pay directly with zero transaction surcharge via any Indian UPI application.',
          ),
        ],
      ),
    ];
  }
}
